Feature: User deleting their own bookmarks.
    Scenario: Admin deleting their own bookmarks backs out at confirmation.
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I click "#delete-button-3" within "main"
        Then I should see "Are you sure you want to delete this bookmark?"
        When I click "#back-button"
        Then I should see "Youtube Video"

    Scenario: User deleting their own bookmarks.
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I click "#delete-button-7" within "main"
        Then I should see "Are you sure you want to delete this bookmark?"
        When I click "#delete-bookmark"
        Then I should see "Bookmark successfully deleted"
        When I click "#back-button"
        Then I should not see "Tree 1"

    Scenario: User tries to delete admin bookmark
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should not see "#delete-button-1" within "main"

    Scenario: Admin tries to delete user bookmark
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should not see "#delete-button-8" within "main"
