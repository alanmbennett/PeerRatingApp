# File for helpful database management functions that other .rb files can use when working with the database

require 'sqlite3'

def openDatabase()
  db = SQLite3::Database.open("peerratingdb.db")
  db.busy_timeout(100) # If database is busy, will sleep and retry to access it in 100ms
  return db
end