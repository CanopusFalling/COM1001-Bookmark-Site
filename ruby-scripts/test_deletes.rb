require 'minitest/autorun'
require_relative 'database-model.rb'
require_relative 'deployment-scripts.rb'

class TestDeletes < Minitest::Test
    Bookmarks.init('../database/test.db')
    Deployment.resetDatabase
    Deployment.testData

    def test_delete_tag_bookmark_link
        assert Bookmarks.deleteTagBookmarkLink(4,18)
        assert Bookmarks.deleteTagBookmarkLink(2,2)

        refute Bookmarks.deleteTagBookmarkLink("two",2)
        refute Bookmarks.deleteTagBookmarkLink(5,"five")
    end

    def test_delete_all_tag_bookmark_links
        assert Bookmarks.deleteAllTagBookmarkLinks(1)
        assert Bookmarks.deleteAllTagBookmarkLinks(3)

        refute Bookmarks.deleteAllTagBookmarkLinks("one")
    end

    def test_delete_all_bookmark_views
        assert Bookmarks.deleteAllBookmarkViews(1)
        assert Bookmarks.deleteAllBookmarkViews(2)
        refute Bookmarks.deleteAllBookmarkViews("three")
    end

    def test_delete_all_bookmark_reports
        assert Bookmarks.deleteAllBookmarkReports(1)
        assert Bookmarks.deleteAllBookmarkReports(3)
        refute Bookmarks.deleteAllBookmarkReports("@")
    end

    def test_delete_all_boomark_comments
        assert Bookmarks.deleteAllBookmarkComments(1)
        assert Bookmarks.deleteAllBookmarkComments(2)
        refute Bookmarks.deleteAllBookmarkComments("@")
    end

    def test_delete_all_bookmark_favourites
        assert Bookmarks.deleteAllBookmarkFavourite(1)
        assert Bookmarks.deleteAllBookmarkFavourite(2)
        refute Bookmarks.deleteAllBookmarkFavourite("four")
    end

    def test_delete_bookmark
        Deployment.resetDatabase
        Deployment.testData
        assert Bookmarks.deleteBookmark(1)
        assert Bookmarks.deleteBookmark(2)
        refute Bookmarks.deleteBookmark("three")
    end
    
    def test_delete_user
        assert Bookmarks.deleteUser(2)
        assert Bookmarks.deleteUser(3)
        refute Bookmarks.deleteUser("four")
    end

end