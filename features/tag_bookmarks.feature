Feature: Viewing tags on Bookmarks
    Scenario: view tags on google boomark
        Given database is reset 
        Given I am on the homepage
        When I follow "Google" within "div#1"
        Then I should see "#Search engines"
        Then I should not see "#Bad search engines"
        Then I should not see "#Tree"

    Scenario: view tags on Bing boomark
        Given I am on the homepage
        When I follow "Bing" within "div#2"
        Then I should see "#Search engines"
        Then I should see "#Bad search engines"
        Then I should not see "#Tree"

    Scenario: view tags on youtube video boomark
        Given I am on the homepage
        When I follow "Youtube Video" within "div#3"
        Then I should not see "#Search engines"
        Then I should not see "#Bad search engines"
        Then I should not see "#Tree"

    Scenario: view tags on youtube video boomark
        Given I am on the homepage
        When I follow "Youtube Video" within "div#3"
        Then I should not see "#Search engines"
        Then I should not see "#Bad search engines"
        Then I should not see "#Tree"

    Scenario: view tags on tree1
        Given I am on the homepage
        When I follow "Tree 1"
        Then I should not see "#Search engines"
        Then I should not see "#Bad search engines"
        Then I should see "#Tree"