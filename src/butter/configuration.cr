require "yaml"

module Butter
  class Configuration
    YAML.mapping(
      homeserver: String,
      enabled_rooms: Array(String),
      prefix: String
    )
  end
end
