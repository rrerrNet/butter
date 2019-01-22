require "./commands/*"

module Butter
  module Bot
    module Commands
      COMMANDS = {{Butter::Bot::Commands::Base.subclasses}}.map do |subclass|
        subclass.commands.map do |cmd|
          {cmd.downcase, subclass}
        end
      end.flatten.to_h

      def self.[](command : String)
        COMMANDS.fetch(command.downcase, UnknownCommand)
      end
    end
  end
end
