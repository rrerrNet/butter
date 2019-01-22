require "../event_context"
require "../../application"

module Butter
  module Bot
    module EventHandler
      abstract class Base
        getter event_context

        def initialize(@event_context : EventContext)
        end

        abstract def handle : Bool

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
