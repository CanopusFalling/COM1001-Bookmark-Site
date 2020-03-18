# Project imports.
require 'sinatra'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'

# For running the server from codio.
set :bind, '0.0.0.0'

Bookmarks.init "../database/test.db"

# Redirect to the index view when a general 
# get connection is opened.
get '/' do
    @results = Bookmarks.getHomepageDataAll
    erb :index
end