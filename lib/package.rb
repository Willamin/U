require 'json'
require 'colorize'
require 'ostruct'
require 'fileutils'
require 'pony'

class U::Package
  @@scripts = {}

  class << self 

    def bootstrap(config_dir)
      if File.directory? config_dir

        config_file = File.join config_dir, 'config'

        if File.exists? config_file
          @@settings = OpenStruct.new JSON.parse(File.read(config_file))
        else
          FileUtils.cp File.join("#{U::ROOT_DIR}", 'default.conf'), File.join(config_dir, 'config')
          @@settings = OpenStruct.new JSON.parse(File.read(config_file))
        end
      else
        Dir.mkdir config_dir
        config_file = File.join config_dir, 'config'

        FileUtils.cp File.join("#{U::ROOT_DIR}", 'default.conf'), File.join(config_dir, 'config')
        @@settings = OpenStruct.new JSON.parse(File.read(config_file))
      end

      # require all the packaged plugins
      #Dir["#{U::PACKAGE_DIR}/**/*.rb"].each { |file| require file[0..-4] }
    end

    def script(name, &block)
      if @@scripts[name].nil?
        @@scripts[name] = block
      else
        raise ArgumentError, "Cannot register the script: \"#{name}\". Script name is already taken."
      end
    end

    def scripts
      @@scripts
    end

    def get_script_params(script)
      script.parameters.flatten.reject { |p| p == :opt }
    end

    def cmd(name)
      @@scripts[name]
    end

    def packages
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def settings
      @@settings
    end

    def uprint(line, level = nil)
      if get_active_app != 'iterm' && @@settings.notify
        TerminalNotifier.notify line
      end

      start = "\n\t"
      stop = "\n"

      if @@settings.colorize
        case level
        when :error
          puts "#{start}#{line}#{stop}".light_red
        when :warn
          puts "#{start}#{line}#{stop}".light_yellow
        else
          puts "#{start}#{line}#{stop}".light_cyan
        end
      else
        puts line
      end
    end

    def get_active_app
      applescript = <<-EOS
        global frontApp, frontAppName, windowTitle

        set windowTitle to ""
        tell application "System Events"
            set frontApp to first application process whose frontmost is true
            set frontAppName to name of frontApp
            tell process frontAppName
                tell (1st window whose value of attribute "AXMain" is true)
                    set windowTitle to value of attribute "AXTitle"
                end tell
            end tell
        end tell

        return {frontAppName, windowTitle}
      EOS

      if U::OS.mac?
        `osascript -e '#{applescript}'`.split(' ')[0].chop.downcase
      else
        nil
      end
    end

    def email options = {}
      if (ENV['U_SMTP_ADDRESS'].nil? ||
        ENV['U_SMTP_PORT'].nil? ||
        ENV['U_EMAIL_ADDRESS'].nil? ||
        ENV['U_EMAIL_PASSWORD'].nil?)

        raise U::Core::FeatureDisabled, "Necessary ENV Variables are missing. Check the README for required email vars."
      end
      params = {
        :via => :smtp,
        :charset => 'utf-8',
        :via_options => {
          :address              => ENV.fetch('U_SMTP_ADDRESS'),
          :port                 => ENV.fetch('U_SMTP_PORT'),
          :enable_starttls_auto => true,
          :user_name            => ENV.fetch('U_EMAIL_ADDRESS'),
          :password             => ENV.fetch('U_EMAIL_PASSWORD'),
          :authentication       => :plain
        }
      }.merge options

      Pony.mail params
    end

    def me
      @@settings.personal_email
    end

    def notify message
      U::Core::Notifier.new.notify message
    end
  end
end
