# Utility functions
def overrides(obj1, obj2)
  obj2.each do |key, value|
    # replace
    replaced_key = key.sub(/_r_/, '')
    if key.start_with?('_r_') and obj1.has_key?(replaced_key) and value.class.name == 'Array'
      obj1[replaced_key] = []
      key = replaced_key
    end

    if obj1.has_key?(key)
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
                  obj1_value.push(val)
                else
                  obj1_value.insert(val['_idx'], val)
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
                    val3 = val
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
        obj1[key] = value
      end
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

def red(text); colorize(text, 31); end
def yellow(text); colorize(text, 33); end

def prompt(message)
  print message
  return STDIN.gets.chomp
end
