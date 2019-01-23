require "markdown"

require "./event_context"
require "./event_handler"

require "../application"
require "../matrix/client"

module Butter
  module Bot
    class Bot
      property running = false,
        next_batch = "",
        own_events = [] of String

      def initialize
        @matrix_client = Matrix::Client.new(Application.config.homeserver)
      end

      def run
        @running = true
        Application.logger.info "Butter is ready!"

        while running
          main_loop
        end
      end

      def main_loop
        ok, response = @matrix_client.sync(ENV["MATRIX_ACCESS_TOKEN"], timeout: 30000, timeline_limit: 0, since: next_batch)
        unless ok
          Application.logger.error "failed to sync matrix for some reason.  waiting 3 seconds until next retry"
          sleep 3
          return
        end

        response = response.not_nil!

        handle_events(response)

        @next_batch = response.next_batch
      end

      private def handle_events(response)
        # handle channel events
        response.rooms.join.each do |room_id, room|
          next unless Application.config.enabled_rooms.includes?(room_id)

          room_events = room.state.events + room.timeline.events
          room_events.each do |ev|
            EventHandler <= EventContext.new(
              event: ev,
              room: room_id
            )
          end
        end
      end

      def send_message(room : String, text : String)
        send_message(
          room: room,
          content: {
            "msgtype" => "m.text",
            "body"    => text,
          }
        )
      end

      def send_message(room : String, text : String, formatted_text : String)
        send_message(
          room: room,
          content: {
            "msgtype"        => "m.text",
            "body"           => text,
            "format"         => "org.matrix.custom.html",
            "formatted_body" => formatted_text,
          }
        )
      end

      def send_markdown(room : String, markdown : String)
        send_message(
          room: room,
          text: markdown,
          formatted_text: Markdown.to_html(markdown)
        )
      end

      private def send_message(room : String, content : Hash(String, String))
        ok, response = @matrix_client.room_send(
          ENV["MATRIX_ACCESS_TOKEN"],
          room_id: room,
          event_type: "m.room.message",
          content: content
        )

        unless ok
          Application.logger.error("sending to room #{room.inspect} failed -- content was: #{content.inspect}")
          return false
        end

        own_events << response.not_nil!.event_id

        true
      end
    end
  end
end
