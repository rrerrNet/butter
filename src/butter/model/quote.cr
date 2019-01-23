require "crecto"

module Butter
  module Model
    class Quote < Crecto::Model
      schema "quotes" do
        field :tag, String
        field :content, String
        field :added_by, String

        field :deleted_at, Time
      end
    end
  end
end
