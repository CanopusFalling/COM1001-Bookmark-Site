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

puts "=== getDetailsByEmail ==="

puts Bookmarks.getDetailsByEmail nil
puts ""
puts Bookmarks.getDetailsByEmail 1
puts ""
puts Bookmarks.getDetailsByEmail "abs"
puts ""
puts Bookmarks.getDetailsByEmail "abc.com"
puts ""

puts "=== getBookmarkDetails ==="
puts Bookmarks.getBookmarkDetails nil
puts ""
puts Bookmarks.getBookmarkDetails "abc"
puts ""
puts Bookmarks.getBookmarkDetails 2
puts ""
puts Bookmarks.getBookmarkDetails 1
puts ""

puts "=== getBookmarkDetails ==="
puts Bookmarks.getBookmarkDetails nil 
puts ""
puts Bookmarks.getBookmarkDetails 0 
puts ""
puts Bookmarks.getBookmarkDetails "abc"
puts ""
puts Bookmarks.getBookmarkDetails 2
puts ""
puts Bookmarks.getBookmarkDetails 3
puts ""
puts Bookmarks.getBookmarkDetails 3
puts ""
puts Bookmarks.getBookmarkDetails 0
puts ""

puts "=== getTagNames ==="
puts Bookmarks.getTagNames
puts ""

puts "=== getTagId ==="
puts Bookmarks.getTagId nil
puts ""
puts Bookmarks.getTagId 4
puts ""
puts Bookmarks.getTagId "ab"
puts ""
puts Bookmarks.getTagId "tag0"
puts ""

puts "=== getTagName ==="
puts Bookmarks.getTagName nil
puts ""
puts Bookmarks.getTagName "hi"
puts ""
puts Bookmarks.getTagName 3
puts ""

puts "=== getBookmarkTagsNames ==="
puts Bookmarks.getBookmarkTagsNames nil
puts ""
puts Bookmarks.getBookmarkTagsNames "hi"
puts ""
puts Bookmarks.getBookmarkTagsNames 1
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

puts"=== getTableNames ==="
puts Bookmarks.getTableNames
puts ""

puts"=== getColumnNames ==="
puts Bookmarks.getColumnNames nil
puts ""
puts Bookmarks.getColumnNames "bookmarks"
puts ""
puts Bookmarks.getColumnNames "bookmark"
puts ""
puts Bookmarks.getColumnNames "edit"
puts ""

puts"=== isUniqueValue ==="
puts Bookmarks.isUniqueValue "bookmarks", "bookmark_title", "title1"  
puts ""
puts Bookmarks.isUniqueValue "bookmark", "bookmark_title", "title1"  
puts ""
puts Bookmarks.isUniqueValue "bookmark", "bookmark_title", "title8"  
puts ""
puts Bookmarks.isUniqueValue nil, "bookmark_title", "title8"  
puts ""

#puts"=== entryExists? ==="
#puts Bookmarks.entryExists? nil, nil
#puts ""
#puts Bookmarks.entryExists? nil, "hahahah"
#puts ""
#puts Bookmarks.entryExists? "hahah", nil
#puts ""
#puts Bookmarks.entryExists? 2, "bookmark"
#puts ""
#puts Bookmarks.entryExists? 65, "bookmark"
#puts ""

puts"=== getAccessDetails ==="
puts Bookmarks.getAccessDetails nil
puts ""
puts Bookmarks.getAccessDetails "sas"
puts ""
puts Bookmarks.getAccessDetails 0
puts ""
puts Bookmarks.getAccessDetails 3
puts ""