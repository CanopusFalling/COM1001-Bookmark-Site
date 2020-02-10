# Simple test code for Sinatra.
# Import the Sinatra gem.
require 'sinatra'

# Bind the server's outgoing IP to 0.0.0.0 
# so it works on Codio.
set :bind, '0.0.0.0'

# Make the root directory of the website 
# show 'Hello World!'.
get '/' do
    'Hello World!'
end
