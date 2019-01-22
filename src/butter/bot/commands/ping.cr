require "./base"
require "../../application"

module Butter
  module Bot
    module Commands
      class Ping < Base
        def self.commands
          ["ping"]
        end

        def call
          Application.logger.info "PING called"
          bot.send_message(
            room: event_context.room,
            text: "PONG"
          )
          true
        end
      end
    end
  end
end
