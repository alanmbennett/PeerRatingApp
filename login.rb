require 'bcrypt'
require 'sqlite3'

# Creates an account unless user already exists in database
# Returns true if successful, returns false if not
def createAccount(username, password, role)
  if userExists?(username) == false
    db = SQLite3::Database.open("peerratingdb.db")
    statement = db.prepare("insert into Users(username, password, role) VALUES(?,?,?)")
    statement.bind_params(username, BCrypt::Password.create(password), role)
    statement.execute
    return true # account creation successful
  end

  return false # user already exists in database so account creation failed
end

# Checks if user already exists in the database and returns whether or not they do
def userExists?(username)
  db = SQLite3::Database.open("peerratingdb.db")
  check_statement = db.prepare("select username from Users where username=?")
  check_statement.bind_params(username)

  check_statement.execute.each do |row|
    if username == row[0]
      return true # Username found in database
    end
  end

  return false # Username not found in database
end

# Checks if the given password of a given user matches the password in the database
def passwordsMatch?(username, password)
  db = SQLite3::Database.open("peerratingdb.db")
  statement = db.prepare("select password from Users where username=?")
  statement.bind_params(username)

  if userExists?(username)
    statement.execute.each do |row|
      if BCrypt::Password.new(row[0]) == password
        return true # Passwords match
      end
    end
  end

  return false # Passwords do not match
end

# Returns the role of the given user, returns null if user not found
def getUserRole(username)
  db = SQLite3::Database.open("peerratingdb.db")
  statement = db.prepare("select role from Users where username=?")
  statement.bind_params(username)

  if userExists?(username)
    statement.execute.each do |row|
        return row[0]
      end
  end

  return null
end

