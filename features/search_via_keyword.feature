Feature: Searching by keyword
    Scenario: search for title from homepage
        Given I am on the homepage
        When I fill in "search_query" with "title" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'title'" within "h2"
        Then I should see "title0" within "section"
        Then I should see "title1" within "section"
        Then I should see "title2" within "section"
        Then I should not see "Google" within "section"
        Then I should not see "なに" within "section"
    
    Scenario: search for google from homepage
        Given I am on the homepage
        When I fill in "search_query" with "google" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'google'" within "h2"
        Then I should see "Google" within "section"
        Then I should not see "title0" within "section"
        Then I should not see "title1" within "section"
        Then I should not see "title2" within "section"
        Then I should not see "なに" within "section"

    Scenario: search for NANI? from homepage
        Given I am on the homepage
        When I fill in "search_query" with "なに" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'なに'" within "h2"
        Then I should see "なに" within "section"
        Then I should not see "title0" within "section"
        Then I should not see "title1" within "section"
        Then I should not see "title2" within "section"
        Then I should not see "Google" within "section"

    Scenario: search for nothing on homepage
        Given I am on the homepage
        When I press "Search" within "form"
        Then I should see "Search results for: ''" within "h2"
        Then I should see "Google" within "section"
        Then I should see "title0" within "section"
        Then I should see "title1" within "section"
        Then I should see "title2" within "section"
        Then I should see "なに" within "section"

    Scenario: search for something not in the database from homepage
        Given I am on the homepage
        When I fill in "search_query" with "123450qwe85yuiofg24hjkl" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: '123450qwe85yuiofg24hjkl'" within "main"
        Then I should see "Try again with a different search..." within "main"
        Then I should not see "なに" within "section"
        Then I should not see "title0" within "section"
        Then I should not see "title1" within "section"
        Then I should not see "title2" within "section"
        Then I should not see "Google" within "section"

    Scenario: Exit a blank search and head back to the homepage
        Given I am on the homepage
        When I press "Search" within "form"
        Then I should see "Search results for: ''" within "h2"
        When I follow "home-link" within "h2"
        Then I should be on the homepage

    Scenario: Exit a search and head back to the homepage
        Given I am on the homepage
        When I fill in "search_query" with "title" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'title'" within "h2"
        When I follow "home-link" within "h2"
        Then I should be on the homepage
