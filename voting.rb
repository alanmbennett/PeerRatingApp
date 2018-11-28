require 'sqlite3'
require './db_management.rb'
require './login.rb'

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

# Given a student username, will return an array with the websites they voted for, array will be ordered by rank
# with index 0 being rank 1 and index 1 being rank 2 and index 2 being rank 3.
def getStudentVoting(username)
  db = openDatabase
  arr = Array.new

  statement = db.prepare("SELECT filepath FROM VotedFor WHERE username=? ORDER BY rank ASC")
  statement.bind_params(username)

  # Pushes all student usernames from database into an array
  statement.execute.each do |row|
    arr.push(row[0])
  end

  return arr
end

# Given a website filepath, will return a hash with arrays of students who voted for the website with each array
# representing a list of students who voted the website as rank 1, 2, and 3.
def getWebsiteVoting(filepath)
  db = openDatabase
  hash = Hash.new()
  hash[1] = Array.new # key 1 represents an array of students who voted the website as rank 1
  hash[2] = Array.new # key 2 represents an array of students who voted the website as rank 2
  hash[3] = Array.new # key 3 represents an array of students who voted the website as rank 3

  statement = db.prepare("SELECT username, rank FROM VotedFor WHERE filepath=?")
  statement.bind_params(filepath)

  statement.execute.each do |row|
      hash[row[1]].push(row[0])
  end

  return hash

end

