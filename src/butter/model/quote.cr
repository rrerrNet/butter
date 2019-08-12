require "granite/adapter/sqlite"

module Butter
  module Model
    class Quote < Granite::Base
      connection butterdb
      table quotes

      column id : Int64, primary: true
      column tag : String?
      column content : String
      column added_by : String

      column created_at : Time
      column updated_at : Time
      column deleted_at : Time?
    end
  end
end
