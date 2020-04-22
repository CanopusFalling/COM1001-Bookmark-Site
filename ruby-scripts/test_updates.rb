require 'minitest/autorun'
require_relative 'database-model.rb'
require_relative 'deployment-scripts.rb'

class TestUpdates < Minitest::Test
    Bookmarks.init('../database/test.db')
    Deployment.resetDatabase
    Deployment.testData

    def test_verify_user
        assert Bookmarks.verifyUser(3)
        assert Bookmarks.verifyUser(4)
        refute Bookmarks.verifyUser("one")
    end

    def test_resolve_reports
        assert Bookmarks.resolveReports(1)
        assert Bookmarks.resolveReports(3)
        refute Bookmarks.resolveReports("five")
    end
   
    def test_suspend_user
        assert Bookmarks.suspendUser(2)
        assert Bookmarks.suspendUser(3)
        refute Bookmarks.suspendUser("x")
    end

    def test_unsuspend_user
        assert Bookmarks.unsuspendUser(2)
        assert Bookmarks.unsuspendUser(3)
        refute Bookmarks.unsuspendUser("x")
    end

    def test_promote_to_admin
        assert Bookmarks.promoteToAdmin(2)
        assert Bookmarks.promoteToAdmin(2)
        refute Bookmarks.promoteToAdmin("user")
    end

    def test_reset_password
        assert Bookmarks.resetPassword(2,"password")
        assert Bookmarks.resetPassword(3,"password123")
        refute Bookmarks.resetPassword("two","p@ssword")
    end
end