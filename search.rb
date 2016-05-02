require 'sqlite3'

input = ARGV[0]

db = SQLite3::Database.new 'test.db', flags: 2, readonly: true
rows = db.execute(" SELECT * FROM tweets WHERE message LIKE '%#{input}%'")

File.open('results.txt', 'w') do |file|
  rows.each do |r|
    file.puts r
  end
end
