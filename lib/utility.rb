# Utility functions
def overrides(obj1, obj2)
  obj2.each do |key, value|
    replaced_key = key.to_s.sub(/_u?[ra]_/, '')

    if !obj1.has_key?(replaced_key)
     if value.class.name == 'Hash'
        obj1[key] = {}
    elsif value.class.name == 'Array'
        obj1[replaced_key] = []
      end
    end

    # replace
    if value.class.name == 'Array'
      if (key.start_with?('_r_') || key.start_with?('_a_') || key.start_with?('_ua_')) && obj1.has_key?(key)
        obj1[replaced_key] = obj1[key].clone
        obj1.delete(key)
      end

      if (key.start_with?('_r_') || key.start_with?('_a_') || key.start_with?('_ua_'))  && !obj1.has_key?(replaced_key)
        obj1[replaced_key] = []
        key = replaced_key
      else
        if key.start_with?('_r_')
          obj1[replaced_key] = []
          key = replaced_key
        elsif key.start_with?('_a_')
          value = obj1[replaced_key].concat(obj2[key])
          key = replaced_key
        elsif key.start_with?('_ua_')
          value = (obj1[replaced_key].concat(obj2[key])).uniq
          key = replaced_key
        end
      end
    end

    if value.class.name == 'Hash'
      obj1[key] = overrides(obj1[key], obj2[key])
    elsif value.class.name == 'Array'
      obj1_value = obj1[key].clone
      if value[0].class.name != 'Hash'
        obj1_value = value
      else
        value.map! do |val|
          if val.class.name == 'Hash'
            id_existing = false
            obj1[key].each do |val1|
              if val1['_id'] == val['_id']
                id_existing = true
                break
              end
            end
            if id_existing == false
              if !val['_op'].nil? and val['_op'] != 'a'
                # warnings
                puts yellow("_op = #{val['_op']} is invalid for non-existing id: #{val}")
              end
              val['_op'] = 'a'
            elsif val['_op'].nil?
              val['_op'] = 'o'
            end

            if val['_op'] == 'a'
              if val['_idx'].nil?
                obj1_value.push(overrides({}, val))
              else
                obj1_value.insert(val['_idx'], overrides({}, val))
              end
            elsif val['_op'] == 'o'
              obj1_value.map! do |val2|
                if val2['_id'] == val['_id']
                  val2 = overrides(val2, val)
                end
                val2
              end
            elsif val['_op'] == 'r'
              obj1_value.map! do |val3|
                if val3['_id'] == val['_id']
                  val3 = overrides({}, val)
                end
                val3
              end
            elsif val['_op'] == 'd'
              obj1_value.delete_if {|val4| val4['_id'] == val['_id'] }
            end
          else
            obj1_value = value
          end
          val
        end
      end
      obj1[key] = obj1_value

    else
      # merge key here
      obj1[key] = value
      # puts yellow('ADDED: try to override non-existing key: ' + key + ' with value: ' + value.to_s)
    end
  end
  #puts JSON.pretty_generate(obj1)
  return obj1
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def get_default_nic()
  default_interface = ""
  if Vagrant::Util::Platform.windows?
      default_interface = %x[wmic.exe nic where "NetConnectionStatus=2" get NetConnectionID | more +1]
      default_interface = default_interface.strip
  elsif Vagrant::Util::Platform.linux?
      default_interface = %x[route | grep '^default' | grep -o '[^ ]*$']
      default_interface = default_interface.strip
  elsif Vagrant::Util::Platform.darwin?
      nicName = %x[route -n get 8.8.8.8 | grep interface | awk '{print $2}']
      default_interface = nicName.strip
      nicString = %x[networksetup -listnetworkserviceorder | grep 'Hardware Port' | grep #{default_interface} | awk -F'[:,]' '{print $2}']
      extension = nicString.strip == "Wi-Fi" ? " (AirPort)" : ""
      default_interface = default_interface + ': ' + nicString.strip + extension
  end
  return default_interface
end

def red(text); colorize(text, 31); end
def yellow(text); colorize(text, 33); end

def prompt(message)
  print message
  return STDIN.gets.chomp
end

# thanks to https://github.com/devopsgroup-io/vagrant-hostmanager/issues/121#issuecomment-69050265

def read_ip_address(machine)
  command = "LANG=en ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1 }'"
  result  = ""

  # $logger.info "Processing #{ machine.name } ... "

  begin
    # sudo is needed for ifconfig
    machine.communicate.sudo(command) do |type, data|
      result << data if type == :stdout
    end
    # $logger.info "Processing #{ machine.name } ... success"
  rescue
    result = "# NOT-UP"
    # $logger.info "Processing #{ machine.name } ... not running"
  end

  # the second inet is more accurate
  result.chomp.split("\n").last
end
