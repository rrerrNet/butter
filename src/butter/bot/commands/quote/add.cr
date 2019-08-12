require "../base"

module Butter
  module Bot
    module Commands
      module Quote
        class Add < Commands::Base
          def self.commands
            ["qa", "quoteadd", "aq", "addquote"]
          end

          def call
            return false unless payload
            return false if payload.not_nil!.strip.empty?
            tag, content = extract_payload

            Application.logger.debug("tag: #{tag.inspect}, content: #{content.inspect}")

            quote = Model::Quote.create!(
              tag: tag,
              content: content,
              added_by: event.sender
            )

            bot.send_markdown(
              room: event_context.room,
              markdown: format_message(quote.id, tag)
            )

            true
          rescue e
            bot.send_markdown(
              room: event_context.room,
              markdown: "Oopsie woopsie uwu, could not add your quote because of this: \n```\n#{e.message}\n```"
            )
            false
          end

          private def extract_payload : {String?, String}
            tag = nil : String?
            stripped_payload = payload.not_nil!.strip

            if match_data = /^[\[(<](?<tag>[^\])>\s_\*]+)[\])>]\s*(?<payload>.+)/.match(stripped_payload)
              tag = match_data["tag"]
              stripped_payload = match_data["payload"]
            end

            {tag, stripped_payload}
          end

          private def format_message(id, tag) : String
            ["Added"].tap do |ary|
              ary << "_#{tag}_" unless tag.nil?
              ary << "quote with id **##{id}**."
            end.join(" ")
          end
        end
      end
    end
  end
end
