require "./base"
require "../../commands"
require "../../../application"

module Butter
  module Bot
    module EventHandler
      class RoomMessage < Base
        def self.event_type
          "m.room.message"
        end

        def handle : Bool
          # ignore file attachments
          return false if event.content.url

          # do not handle messages from myself
          return false if bot.own_events.delete(event.event_id)

          # ignore redacted messages
          return false unless event.content.body && event.content.msgtype

          # ignore actions
          return false if is_action?

          body = event.content.body.not_nil!

          return false unless body.starts_with?(Application.config.prefix)
          cmd, payload = parse_message(body)

          Application.logger.debug("body = #{body.inspect}, cmd = #{cmd.inspect}, payload: #{payload.inspect}")
          Commands[cmd].call(event_context, payload)

          true
        end

        private def is_action?
          event.content.msgtype == "m.emote"
        end

        private def parse_message(body : String) : {String, String?}
          cmd = body
          payload = nil : String?

          if body.includes?(" ")
            cmd, payload = body.split(" ", 2)
          end
          cmd = cmd.sub(Application.config.prefix, "").downcase

          {cmd, payload}
        end
      end
    end
  end
end
