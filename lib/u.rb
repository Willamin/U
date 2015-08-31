require 'pathname'

module U
  VERSION = '1.0.0'
  ROOT_DIR = Pathname.new(File.join(__dir__, '../')).expand_path.to_s
  CONFIG_DIR = "#{Dir.home}/.u"
  PACKAGE_DIR = File.join CONFIG_DIR, 'packages'

  module Core
    class FeatureDisabled < StandardError; end
  end

  module OS
    class << self
      def windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      end

      def mac?
       (/darwin/ =~ RUBY_PLATFORM) != nil
      end

      def unix?
        !OS.windows?
      end

      def linux?
        OS.unix? and not OS.mac?
      end
    end
  end
end
