Feature: view bookmark
    Scenario: Click on first bookmark
        Given I am on the homepage
        When I click ".bookmark-details" within "div#1"
        Then I should be on bookmark spesifics
        Then I should see "Google" within ".bookmark-title"
        Then I should see "Link to the popular search engine google." within ".bookmark-description"
        Then I should see "Created on 2020-04-06 by Testing Admin" within ".detailed-info"
        Then I should see "Rating: 2.5/5 (4)" within ".rating"