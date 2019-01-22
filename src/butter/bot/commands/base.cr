require "../event_context"
require "../../application"

module Butter
  module Bot
    module Commands
      abstract class Base
        def self.call(event_context, payload)
          new(event_context, payload).call
        end

        getter payload, event_context

        def initialize(@event_context : EventContext, @payload : String? = nil)
        end

        abstract def call : Bool

        private def bot
          Application.bot
        end

        private def event
          event_context.event
        end
      end
    end
  end
end
