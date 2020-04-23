require 'minitest/autorun'
require_relative 'database-model.rb'
require_relative 'deployment-scripts.rb'

class TestDeploymentScripts < Minitest::Test
    Bookmarks.init('../database/test.db')

    def test_reset_database
        Deployment.resetDatabase
        assert_equal 0, Bookmarks.getHomepageDataAll.length
        assert_equal 0, Bookmarks.currentUserEmails.length
        assert_equal 0, Bookmarks.getTagNames.length
    end

    def test_data
        Deployment.testData
        assert_equal 18, Bookmarks.getHomepageDataAll.length
        assert_equal 6, Bookmarks.currentUserEmails.length
        assert_equal 4, Bookmarks.getTagNames.length
    end
end