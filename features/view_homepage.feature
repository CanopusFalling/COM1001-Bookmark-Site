Feature: view homepage
    Scenario: opens website
        Given database is reset
        Given I am on the homepage
        Then I should be on the homepage