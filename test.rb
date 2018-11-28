# Attention: File meant for sandbox purposes only

require 'sqlite3'
require './db_management.rb'

db = openDatabase

db.execute("select * from Users") do |result|
  print result
end

#db.execute("CREATE TABLE Websites (filePath varchar(255), orderOfUpload int);");
#db.execute("CREATE TABLE VotedFor (username varchar(50), filePath varchar(255), rank int);");

puts "---"

db.execute("select * from Websites") do |result|
  print result
end

puts "---"

db.execute("select * from VotedFor") do |result|
  print result
end
