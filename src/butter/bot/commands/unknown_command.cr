require "./base"

module Butter
  module Bot
    module Commands
      class UnknownCommand < Base
        def self.commands
          [] of String
        end

        def call
          false
        end
      end
    end
  end
end
