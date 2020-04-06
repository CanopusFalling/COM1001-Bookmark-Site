Feature: Searching by keyword
    Scenario: search for title
        Given I am on the homepage
        When I fill in "search_query" with "title" within "form"
        When I press button "search" within "form"