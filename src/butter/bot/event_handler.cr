require "./event_context"
require "./event_handler/*"

module Butter
  module Bot
    module EventHandler
      HANDLERS = {{Butter::Bot::EventHandler::Base.subclasses}}.map do |subclass|
        {subclass.event_type.downcase, subclass}
      end.to_h

      def self.[](event_type : String)
        HANDLERS.fetch(event_type.downcase, UnknownEvent)
      end

      def self.<=(event_context) : Bool
        self[event_context.event.type].new(event_context).handle
      end
    end
  end
end
