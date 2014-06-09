# Utility functions
def overrides(obj1, obj2)
  obj2.each do |key, value|

    if obj1.has_key?(key)
      if value.class.name == 'Hash'
        obj1[key] = overrides(obj1[key], obj2[key])
      else
        obj1[key] = value
      end
    else
      puts yellow('IGNORED: try to override non-existing key: ' + key)
    end

  end
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