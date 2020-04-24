Feature: Logout
    Scenario: Logout of default user
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
        When I follow "Log Out" within "header"
        Then I should not see "Profile" within "header"
        Then I should not see "Create Bookmark" within "header"
        Then I should see "Login" within "header"
        Then I should see "Register" within "header"

    Scenario: Logout of default user then login again
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
        When I follow "Log Out" within "header"
        Then I should not see "Profile" within "header"
        Then I should not see "Create Bookmark" within "header"
        Then I should see "Login" within "header"
        Then I should see "Register" within "header"
        When I follow "Login" within "header"
        When I fill in "user-email" with "user" within "section"
        When I fill in "user-password" with "user" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"

    Scenario: Logout of admin
        Given database is reset
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
        When I follow "Log Out" within "header"
        Then I should not see "Profile" within "header"
        Then I should not see "Create Bookmark" within "header"
        Then I should see "Login" within "header"
        Then I should see "Register" within "header"
