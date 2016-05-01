require 'twitter'
require 'pry'
require 'sqlite3'

# Configure Twitter sreaming client
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "02D2nhEuIJi1xnu7TVRNchisr"
  config.consumer_secret     = "rBLwjYfpJqvVON0a45PvpRg1lHcuytutQtwjos9n8Y1yCK75Dy"
  config.access_token        = "718823565521514496-QUKUboFvzMA8xn38OMAWdBftJQ8ummJ"
  config.access_token_secret = "QXEHuAXrsoXJvEqJmTruWWdbdSiGr16JUb1ljewhHSKDc"
end

# Configure SQLite3 DB
db = SQLite3::Database.new "test.db"

# create a table
rows = db.execute <<-SQL
  create table tweets (
    message varchar(140)
  );
SQL

# insert tweets
begin
  client.sample do |object|
    if object.is_a?(Twitter::Tweet) && object.lang == 'en' && !object.text.empty?
      db.execute "INSERT INTO tweets (message) values (?);", "#{object.text}\n"
    end
  end
ensure
  db.close
end
