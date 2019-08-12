require "./base"
require "../../application"

module Butter
  module Bot
    module EventHandler
      class UnknownEvent < Base
        def self.event_type
          "butter.internal.unknown"
        end

        def handle : Bool
          Application.logger.debug("ignoring unknown event #{event.type.inspect}")
          true
        end
      end
    end
  end
end
