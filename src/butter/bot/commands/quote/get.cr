require "markdown"
require "random/secure"

require "../base"

module Butter
  module Bot
    module Commands
      module Quote
        class Get < Commands::Base
          def self.commands
            ["q", "quote"]
          end

          def call
            id = id_from_payload_or_random_id_from_tag || fetch_random_id

            quote = Connection::Sqlite.get(Model::Quote, id)
            return quote_not_found(id) unless quote
            quote = quote.as(Model::Quote)
            return quote_not_found(id) unless quote.content || quote.added_by

            bot.send_message(
              room: event_context.room,
              text: format_plain_message(quote),
              formatted_text: format_html_message(quote)
            )

            true
          rescue e
            bot.send_markdown(
              room: event_context.room,
              markdown: "Oopsie woopsie uwu, could not fetch a quote because of this: \n```\n#{e.message}\n```"
            )
            false
          end

          private def id_from_payload_or_random_id_from_tag
            return if payload.nil?
            return if payload.not_nil!.strip.empty?
            id = id_from_payload
            return id unless id.nil?
            fetch_random_id(payload)
          end

          private def id_from_payload
            return if payload.nil?
            return if payload.not_nil!.strip.empty?
            return unless /^[0-9]+$/.match(payload.not_nil!.strip)
            payload.not_nil!.strip.to_i64
          rescue
            nil
          end

          private def fetch_random_id(tag : String? = nil)
            query = Connection::Sqlite::Query
              .select(["id"])
              .where(deleted_at: nil)
            query.where("LOWER(tag) = ?", [tag.strip.downcase]) if tag
            ids = Connection::Sqlite
              .all(Model::Quote, query)
              .map(&.id)
            return if ids.empty?
            ids.sample(random: Random::Secure)
          end

          private def quote_not_found(id)
            params = if payload && !id_from_payload && payload.not_nil!.empty?
                       "tag _#{payload.not_nil!.strip}_"
                     else
                       "id ##{id}"
                     end
            bot.send_markdown(
              room: event_context.room,
              markdown: "Could not find any quote with #{params} ;_;"
            )
            false
          end

          private def format_plain_message(quote) : String
            ["**Quote ##{quote.id}**#{tag_str(quote)}:\n\n"].tap do |ary|
              ary << quote.content.not_nil!.split("\n").map { |line| ">#{line}" }.join("\n")
              ary << "\n\nAdded by #{quote.added_by} on #{quote.created_at}"
            end.join("")
          end

          private def format_html_message(quote) : String
            ["<p><strong>Quote ##{quote.id}</strong>#{tag_str(quote)}:</p>\n\n"].tap do |ary|
              ary << "<blockquote>"
              ary << Markdown.to_html(quote.content.not_nil!)
              ary << "</blockquote>"
              ary << "\n\n<p>Added by #{quote.added_by} on #{quote.created_at}</p>"
            end.join("")
          end

          private def tag_str(quote)
            return " (#{quote.tag})" if quote.tag
            ""
          end
        end
      end
    end
  end
end
