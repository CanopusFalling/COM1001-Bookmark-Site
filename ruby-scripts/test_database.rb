require 'sqlite3'
require_relative 'database-model.rb'

#Run this script from project directory
Bookmarks.init '../database/test.db'

puts "=== currentUserEmails ==="
puts Bookmarks.currentUserEmails
puts ""

puts"=== getHomepageDataAll ==="
puts Bookmarks.getHomepageDataAll
puts ""

puts"=== getHomepageData ==="
puts Bookmarks.getHomepageData nil
puts ""
puts Bookmarks.getHomepageData 1
puts ""
puts Bookmarks.getHomepageData "lampa"
puts ""

puts "=== getPasswordHash ==="

puts Bookmarks.getPasswordHash nil
puts ""
puts Bookmarks.getPasswordHash 1
puts ""
puts Bookmarks.getPasswordHash "abs"
puts ""
puts Bookmarks.getPasswordHash "abc.com"
puts ""

puts "=== getGuestBookmarkDetails ==="
puts Bookmarks.getGuestBookmarkDetails nil
puts ""
puts Bookmarks.getGuestBookmarkDetails "abc"
puts ""
puts Bookmarks.getGuestBookmarkDetails 2
puts ""
puts Bookmarks.getGuestBookmarkDetails 1
puts ""

puts "=== getBookmarkDetails ==="
puts Bookmarks.getBookmarkDetails nil , nil
puts ""
puts Bookmarks.getBookmarkDetails 0 , nil
puts ""
puts Bookmarks.getBookmarkDetails nil , 0
puts ""
puts Bookmarks.getBookmarkDetails "abc", 0
puts ""
puts Bookmarks.getBookmarkDetails 2, 0
puts ""
puts Bookmarks.getBookmarkDetails 3, 2
puts ""
puts Bookmarks.getBookmarkDetails 0, "abc"
puts ""

puts "=== getTagNames ==="
puts Bookmarks.getTagNames
puts ""

puts "=== geUserDetails ==="
puts Bookmarks.getUserDetails 0
puts ""
puts Bookmarks.getUserDetails nil
puts ""
puts Bookmarks.getUserDetails "abc"
puts ""

puts"=== getFavouriteList ==="
puts Bookmarks.getFavouriteList nil
puts ""
puts Bookmarks.getFavouriteList "abc"
puts ""
puts Bookmarks.getFavouriteList 1
puts ""

puts"=== getUnverifiedUsers ==="
puts Bookmarks.getUnverifiedList
puts ""

puts"=== getVerifiedUsers ==="
puts Bookmarks.getVerifiedList
puts ""

puts"=== getViewHistory ==="
puts Bookmarks.getViewHistory nil
puts ""
puts Bookmarks.getViewHistory "abs"
puts ""
puts Bookmarks.getViewHistory 0.0
puts ""
puts Bookmarks.getViewHistory 0
puts ""

puts"=== getUnresolvedReports ==="
puts Bookmarks.getUnresolvedReports
puts ""

puts"=== getReportedBookmarkDetails ==="
puts Bookmarks.getReportedBookmarkDetails nil
puts ""
puts Bookmarks.getReportedBookmarkDetails "asfw"
puts ""
puts Bookmarks.getReportedBookmarkDetails 1
puts ""
puts Bookmarks.getReportedBookmarkDetails 3
puts ""
