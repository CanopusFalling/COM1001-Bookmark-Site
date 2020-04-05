Feature: view bookmark
    Scenario: Click on first bookmark
        Given I am on the homepage
        When I click ".bookmark-details" within "div#0"
        Then I should be on bookmark spesifics
        Then I should see "title0" within ".bookmark-title"
        Then I should see "desc0" within ".bookmark-description"
        Then I should see "Created on 10.12.1999 by User0" within "detailed-info"