# Project imports.
require 'sinatra'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'
require_relative 'user-authentication.rb'
require_relative 'ruby-scripts/support-functions.rb'
# For running the server from codio.
set :bind, '0.0.0.0'
enable :sessions

Bookmarks.init "../database/test.db"

before do
    if !session[:userID] 
        session[:userID] = -1
    end
end

# Redirect to the index view when a general 
# get connection is opened.
get '/' do
    
    @results = Bookmarks.getHomepageDataAll
    erb :index
end

get '/login' do
    if session[:userID] == -1 
        erb :loginPage
    else
        redirect '/'
    end
end

get '/registration' do
    erb :registration
end

post '/registration' do

    @error_msg = getErrorMessage params
    @displayName = params[:displayName]
    @email = params[:email]
    @email_valid = params[:email_validation]
    
    if @error_msg == ""
        newUser @displayName , @email, params[:password]
        redirect '/'
    else
        erb:registration
    end

end

# Search handling.
get '/search' do
    req = Rack::Request.new(env)
    req.post?
    @searchQuery = req.params["search_query"]

    @results = Bookmarks.getHomepageData @searchQuery
    
    if(!@results.nil?) then
        erb :search
    else
        erb :noResults
    end
end

post '/authenticate-user' do

    @login = params[:user_email]
    @password = params[:user_password]

    session[:userID] = UserAuthentication.check @login , @password
    if session[:userID] == -1
        @error = "Invalid login or password."
        erb :loginPage
    else
        redirect '/'
    end

end