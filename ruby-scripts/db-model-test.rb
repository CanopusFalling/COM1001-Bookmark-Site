
require_relative 'database-model.rb'
include Bookmarks
Bookmarks.init('../database/test.db')

result = Bookmarks.getDetailsByEmail("email@email.com")

puts "#{result[:type]}"


