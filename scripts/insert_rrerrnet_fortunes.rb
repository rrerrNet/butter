#!/usr/bin/env ruby
# frozen_string_literal: false

FORTUNE_URL =
  "https://raw.githubusercontent.com/rrerrNet/fortunes/master/rrerrnet".freeze
DB_PATH = File.expand_path("~/.butterdb").freeze
SELF_ID = "@butter:example.org".force_encoding("utf-8").freeze
QUOTE_TAG = "rrerrNet".force_encoding("utf-8").freeze

# - # - # - # - # - # - # - # - # - # - # - # - # - # - # - # - # - # - # - #

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "sqlite3", "~> 1.3"
  gem "faraday", "~> 0.15"
end

STDOUT.sync = true
print "fetching fortunes..."
fortunes = Faraday.get(FORTUNE_URL).body.split("%").map(&:strip)
puts " f#{fortunes.count} fortunes found"

def now_timestamp
  Time.now.utc.strftime("%Y-%m-%d %H:%M:%S.%L")
end

print "inserting fortunes"
db = SQLite3::Database.new(DB_PATH)
fortunes.each do |fortune|
  print ">"
  db.execute(
    %Q|INSERT INTO quotes (tag, content, added_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?)|,
    [
      QUOTE_TAG,
      fortune.force_encoding("utf-8"),
      SELF_ID,
      now_timestamp.force_encoding("utf-8"),
      now_timestamp.force_encoding("utf-8")
    ]
  )
  print "\b."
end

puts " done!"
