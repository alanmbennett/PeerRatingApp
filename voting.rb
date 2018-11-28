require 'sqlite3'
require './db_management.rb'

# Returns true if Vote was successful, returns false if Vote failed
def vote(username, filepath, rank)
  db = openDatabase

  # Check to see if vote already exists
  if voteExists?(username, rank)
    return false # Not able to add vote due to already existing
  end

  # Check to see if user already voted for that website
  if votedForWebsiteAlready?(username, filepath)
    return false # Not able to add vote due to already existing
  end

  # Add vote to VoteFor table
  statement = db.prepare("insert into VotedFor(username, filePath, rank) VALUES(?,?,?)")
  statement.bind_params(username, filepath, rank)
  statement.execute
  return true # Vote was able to be added
end

def voteExists?(username, rank)
  db = openDatabase

  statement = db.prepare("select username, rank from VotedFor where username=? and rank=?")
  statement.bind_params(username, rank)

  statement.execute.each do |row|
    if username == row[0]
      if rank == row[1]
        return true # Vote for that rank found in database
      end
    end
  end

  return false # Vote for that rank not found in database
end

def votedForWebsiteAlready?(username, filepath)
  db = openDatabase

  statement = db.prepare("select username, filepath from VotedFor where username=? and filepath=?")
  statement.bind_params(username, filepath)

  statement.execute.each do |row|
    if username == row[0]
      if filepath == row[1]
        return true # Vote for that website found
      end
    end
  end

  return false # Vote not found for that website
end

#puts vote("coolkid", "/anotherwebsite.html", 3)