# Project imports.
require 'sinatra'

# For running the server from codio.
set :bind, '0.0.0.0'

# Redirect to the index view when a general 
# get connection is opened.
get '/' do
    erb :index
end