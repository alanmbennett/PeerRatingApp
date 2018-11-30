require 'sqlite3'
require './db_management.rb'
require './login.rb'

# Given a website filepath, the website will be added to the database
# Returns true if website insertion to database was successful
# Returns false if website already exists in database
def addWebsite(filepath)
  db = openDatabase

  if websiteExists?(filepath)
    return false
  end

  statement = db.prepare("insert into Websites(filePath, orderOfUpload) VALUES(?,?)")
  statement.bind_params(filepath, websiteCount + 1)
  statement.execute

  return true
end

# Returns the number of websites in database
def websiteCount()
  db = openDatabase
  count = 0
  statement = db.prepare("select COUNT(*) from Websites")
  statement.execute.each do |row|
    count = row[0]
  end

  return count
end

# Returns if a website exists or not
def websiteExists?(filepath)
  db = openDatabase
  check_statement = db.prepare("select filePath from Websites where filePath=?")
  check_statement.bind_params(filepath)

  check_statement.execute.each do |row|
    if filepath == row[0]
      return true # Website found in database
    end
  end

  return false # Website not found in database
end

# Given a username, will return an array of websites to display. If user is a student, the array will be randomized.
# If the user is TA or instructor then the array will be displayed ordered

def getArrayOfWebsites(username)
  db = openDatabase
  arr = Array.new

  statement = db.prepare("SELECT filepath FROM Websites ORDER BY orderOfUpload ASC")

  # Pushes all website filepaths from database into an array
  statement.execute.each do |row|
    arr.push(row[0])
  end

  # If user is a student, the array will be randomized
  if isStudent?(username)
    return arr.shuffle
  end

  return arr
end


post '/uploadWeb' do
  if session[:killer]
      unless params[:file] &&
          (tmpfile = params[:file][:tempfile]) &&
          (name = params[:file][:filename])
        @error = "No file selected"
        return haml(:upload)
      end
      STDERR.puts "Uploading file, original name #{name.inspect}"
      while blk = tmpfile.read(65536)
        # here you would write it to its final location
        STDERR.puts blk.inspect
      end
      "Upload complete"
    redirect to('/login')
  end
    redirect to('/killer')
end