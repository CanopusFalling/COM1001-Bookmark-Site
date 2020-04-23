require 'minitest/autorun'
require_relative 'database-model.rb'
require_relative 'deployment-scripts.rb'

class TestUserAuthentication < Minitest::Test
    Bookmarks.init('../database/test.db')
    Deployment.resetDatabase
    Deployment.testData

    def test_check
        assert_equal 1, UserAuthentication.check('admin','admin')
        assert_equal 3, UserAuthentication.check('role1','role1')

        assert_equal -1, UserAuthentication.check('role2','password')
        assert_equal -1, UserAuthentication.check('role3','p@ssword')
    end

    def test_password_reset
        Bookmarks.resetPassword(5,"password")
        Bookmarks.resetPassword(6,"password")

        assert UserAuthentication.hasPasswordReset("role3")
        assert UserAuthentication.hasPasswordReset("role4")

        refute UserAuthentication.hasPasswordReset("user")
        refute UserAuthentication.hasPasswordReset("role1")
    end

    def test_get_access_level
        assert_equal 0, UserAuthentication.getAccessLevel(-1)
        assert_equal 0, UserAuthentication.getAccessLevel(3)
        assert_equal 1, UserAuthentication.getAccessLevel(2)
        assert_equal 2, UserAuthentication.getAccessLevel(1)
    end

    def test_has_edit_rights
        assert UserAuthentication.hasEditRights(1,1)
        assert UserAuthentication.hasEditRights(12,2)

        refute UserAuthentication.hasEditRights(12,4)
        refute UserAuthentication.hasEditRights(18,2)
    end

end