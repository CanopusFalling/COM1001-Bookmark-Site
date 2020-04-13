Feature: Editing Bookmarks
    Scenario: Admin editing their own bookmarks.
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I click "#edit-button-1" within "main"
        Then I should see "Edit Google bookmark"
        When I fill in "bookmark-title" with "ELGOOG" within "main"
        When I fill in "bookmark-link" with "elgoog.com" within "main"
        When I fill in "bookmark-description" with "elgoog enigne hcraes ralupop os ton eht ot knil" within "main"
        When I click "#edit-bookmark" within "main"
        Given I am on the homepage
        Then I should see "ELGOOG"
        When I follow "ELGOOG" within "main"
        Then I should see "elgoog enigne hcraes ralupop os ton eht ot knil" within ".bookmark-description"
        Then I should see "by Testing Admin" within ".detailed-info"
        Then I should see "Rating: 2.5/5 (4)" within ".rating"
        Then I should see "#Search engine"


    Scenario: User editing their own bookmarks.
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I click "#edit-button-7" within "main"
        Then I should see "Edit Tree 1 bookmark"
        When I fill in "bookmark-title" with "ELGOOG" within "main"
        When I fill in "bookmark-link" with "elgoog.com" within "main"
        When I fill in "bookmark-description" with "elgoog enigne hcraes ralupop os ton eht ot knil" within "main"
        When I click "#edit-bookmark" within "main"
        Given I am on the homepage
        Then I should see "ELGOOG"
        When I follow "ELGOOG" within "main"
        Then I should see "elgoog enigne hcraes ralupop os ton eht ot knil" within ".bookmark-description"
        Then I should see "by Testing User" within ".detailed-info"
        Then I should see "Rating: 3.5/5 (2)" within ".rating"
        Then I should see "#Tree"