Feature: User deleting their own bookmarks.
        Scenario: Admin deleting their own bookmarks backs out at confirmation.
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

    Scenario: Admin deleting their own bookmarks.
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I click "#delete-button-3" within "main"
        Then I should see "Are you sure you want to delete this bookmark?"
        When I click "#delete-bookmark"
        Then I should see "Bookmark successfully deleted"
        When I click "#back-button"
        Then I should not see "Youtube Video"
