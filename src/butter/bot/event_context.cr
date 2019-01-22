require "../../matrix/entities/sync_response"

module Butter
  module Bot
    class EventContext
      getter event : Matrix::Entities::SyncResponse::Room::Event,
        room : String

      def initialize(@event, @room)
      end
    end
  end
end
