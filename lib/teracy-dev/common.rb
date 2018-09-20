module TeracyDev
  class Common
    def self.colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def self.red(text)
      colorize(text, 31)
    end

    def self.yellow(text)
      colorize(text, 33)
    end

    def self.green(text)
      colorize(text, 32)
    end

    def self.light_gray(text)
      colorize(text, 37)
    end

    def self.prompt(message)
      print message
      return STDIN.gets.chomp
    end
  end
end
