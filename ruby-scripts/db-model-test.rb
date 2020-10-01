
require_relative 'database-model.rb'
require_relative 'deployment-scripts.rb'
require_relative 'user-authentication.rb'
require_relative 'support-functions.rb'
include Bookmarks
Bookmarks.init('../database/test.db')


Deployment.resetDatabase
Deployment.testData






