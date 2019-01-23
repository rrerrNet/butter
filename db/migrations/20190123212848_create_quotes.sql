-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE IF NOT EXISTS quotes (
  id         INTEGER   PRIMARY KEY NOT NULL,
  tag        TEXT,
  content    TEXT                  NOT NULL,
  added_by   TEXT                  NOT NULL,
  created_at TIMESTAMP             NOT NULL,
  updated_at TIMESTAMP             NOT NULL,
  deleted_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE quotes;
