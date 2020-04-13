Feature: Employee login
    Scenario: login as default user
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
    
    Scenario: login as role1 user
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "role1" within "section"
        When I fill in "user-password" with "role1" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
    
    Scenario: login as role2 user
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "role2" within "section"
        When I fill in "user-password" with "role2" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"

    Scenario: login as role3 user
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "role3" within "section"
        When I fill in "user-password" with "role3" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"

    Scenario: login as role4 user
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "role4" within "section"
        When I fill in "user-password" with "role4" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
