require "sqlite3"
require "crecto"

module Butter
  module Connection
    module Sqlite
      extend Crecto::Repo

      Query = Crecto::Repo::Query

      config do |conf|
        conf.adapter = Crecto::Adapters::SQLite3
        conf.database = File.expand_path("~/.butterdb")
      end
    end
  end
end
