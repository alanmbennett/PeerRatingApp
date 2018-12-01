require 'sinatra'
require './login'
require './website_upload'

enable(:sessions)

get '/' do
  redirect to('/login')
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