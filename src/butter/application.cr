require "logger"
require "option_parser"
require "secrets"

require "./configuration"
require "./bot/bot"
require "./matrix/client"

module Butter
  VERSION = "0.1.0"

  class Application
    def self.run(argv)
      new(argv.dup).run
    end

    def self.matrix_access_token
      ENV["MATRIX_ACCESS_TOKEN"]
    end

    def self.bot
      @@bot
    end

    def self.config
      @@config
    end

    def self.logger
      @@logger ||= Logger.new(
        STDOUT, level: Logger::Severity.parse(ENV.fetch("LOG_LEVEL", "DEBUG"))
      )
    end

    @@config = Configuration.from_yaml({{ run("./macro_utils/read", __DIR__, "../../config.example.yml").stringify }})
    @@config_set = false
    @@bot = Bot::Bot.new

    def initialize(@argv : Array(String)); end

    def run
      optparser = OptionParser.new do |parser|
        parser.banner = "Usage: butter [arguments]"

        parser.on("-c CONFIG", "--config CONFIG", "Read configuration from this file") do |config_path|
          @@config = Configuration.from_yaml(File.read(config_path))
          @@config_set = true
        end
        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit 0
        end

        parser.invalid_option do |flag|
          STDERR.puts "error: #{flag} is not a valid option."
          STDERR.puts parser
          exit 1
        end
      end

      optparser.parse(@argv)

      unless @@config_set
        STDERR.puts "error: --config was not set"
        STDERR.puts optparser
        exit 1
      end

      @@bot = Bot::Bot.new

      # TODO: store those things in a database, maybe?
      unless ENV.has_key?("MATRIX_ACCESS_TOKEN")
        puts "Performing first time login on #{@@config.homeserver}"
        print "Username: "
        username = gets
        if username.nil?
          puts "Oopsie woopsie uwu"
          exit 1
        end
        username = username.not_nil!.strip
        password = Secrets.gets("Password: ")

        ok, response = Matrix::Client.new(@@config.homeserver).login(username, password)

        unless ok
          puts "Oopsie woopsie uwu"
          exit 1
        end

        access_token = response.not_nil!.access_token

        puts
        puts "Your access token is: #{access_token}"
        puts
        puts "Please place it in your ENV like this:"
        puts "   setenv MATRIX_ACCESS_TOKEN #{access_token.inspect}"
        puts "                            ----- or -----"
        puts "   export MATRIX_ACCESS_TOKEN=#{access_token.inspect}"
        puts

        exit
      end

      @@bot.run
    end
  end
end
