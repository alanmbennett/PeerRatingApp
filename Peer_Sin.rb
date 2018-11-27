require 'sinatra'
require './login'

enable(:sessions)

get '/' do
  "This exists"
end

get '/killer'do
  if session[:killer] != true
    redirect to('/login')
  end
    erb :ta
end

get '/stud'do
  if session[:stud] != true
    redirect to('/login')
  end
  erb :stud
end