Feature: Searching by keyword
    Scenario: search for Google from homepage
        Given database is reset
        Given I am on the homepage
        When I fill in "search_query" with "Google" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'Google'" within "h2"
        Then I should see "Google" within "section"
        Then I should see "Google Maps" within "section"
        Then I should see "Google News" within "section"
        Then I should see "54" within "section"
        Then I should see "0" within "section"
        Then I should not see "Youtube" within "section"
        Then I should not see "Repository" within "section"
        Then I should not see "Tree" within "section"
        Then I should not see "Bing" within "section"
        Then I should not see "Jeeves" within "section"
        Then I should not see "Laundry" within "section"
        Then I should not see "RSI - NHS" within "section"
    
    Scenario: search for Tree from homepage
        Given I am on the homepage
        When I fill in "search_query" with "Tree" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'Tree'" within "h2"
        Then I should see "Tree 1" within "section"
        Then I should see "Tree 2" within "section"
        Then I should see "Tree 3" within "section"
        Then I should see "Tree 4" within "section"
        Then I should see "Tree 5" within "section"
        Then I should see "Tree 6" within "section"
        Then I should not see "Youtube" within "section"
        Then I should not see "Repository" within "section"
        Then I should not see "Google" within "section"
        Then I should not see "Bing" within "section"
        Then I should not see "Jeeves" within "section"
        Then I should not see "Laundry" within "section"
        Then I should not see "RSI - NHS" within "section"

    Scenario: search for bing from homepage
        Given I am on the homepage
        When I fill in "search_query" with "Bing" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'Bing'" within "h2"
        Then I should see "Bing" within "section"
        Then I should see "Bing News" within "section"
        Then I should not see "Youtube" within "section"
        Then I should not see "Repository" within "section"
        Then I should not see "Tree" within "section"
        Then I should not see "Google" within "section"
        Then I should not see "Jeeves" within "section"
        Then I should not see "Laundry" within "section"
        Then I should not see "RSI - NHS" within "section"

    Scenario: search for nothing on homepage
        Given I am on the homepage
        When I press "Search" within "form"
        Then I should see "Search results for: ''" within "h2"
        Then I should see "Youtube" within "section"
        Then I should see "Repository" within "section"
        Then I should see "Tree" within "section"
        Then I should see "Google" within "section"
        Then I should see "Jeeves" within "section"
        Then I should see "Laundry" within "section"
        Then I should see "RSI - NHS" within "section"
        Then I should see "Bing" within "section"

    Scenario: search for something not in the database from homepage
        Given I am on the homepage
        When I fill in "search_query" with "123450qwe85yuiofg24hjkl" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: '123450qwe85yuiofg24hjkl'" within "main"
        Then I should see "Try again with a different search..." within "main"
        Then I should not see "Youtube" within "section"
        Then I should not see "Repository" within "section"
        Then I should not see "Google" within "section"
        Then I should not see "Bing" within "section"
        Then I should not see "Jeeves" within "section"
        Then I should not see "Laundry" within "section"
        Then I should not see "RSI - NHS" within "section"
        Then I should not see "Tree" within "section"

    Scenario: Exit a blank search and head back to the homepage
        Given I am on the homepage
        When I press "Search" within "form"
        Then I should see "Search results for: ''" within "h2"
        When I follow "home-link" within "h2"
        Then I should be on the homepage

    Scenario: Exit a search and head back to the homepage
        Given I am on the homepage
        When I fill in "search_query" with "Google" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: 'Google'" within "h2"
        When I follow "home-link" within "h2"
        Then I should be on the homepage

    Scenario: Exit a blank search and head back to the homepage
        Given I am on the homepage
        When I fill in "search_query" with "-----" within "form"
        When I press "Search" within "form"
        Then I should see "Search results for: '-----'" within "section"
        When I follow "home-link" within "section"
        Then I should be on the homepage
