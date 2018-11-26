require 'sqlite3'

db = SQLite3::Database.open('peerratingdb.db')

db.execute("select * from Users") do |result|
  print result
end

