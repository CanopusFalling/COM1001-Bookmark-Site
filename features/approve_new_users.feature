Feature: Approve new users
    Scenario: Admin approves role 1
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I follow "Admin" within "header"
        Then I should see "Approve New Users"
        When I follow "Approve New Users"
        Then I should see "Testing Unapproved User"
        Then I should see "role1"
        Then I should see "Customer Service"
        Then I should see "TestingRole2"
        Then I should see "role2"
        Then I should see "Customer Service"
        When I click "#verify-user3"
        Then I should see "Are you sure you verify this user and grant them access to the system?"
        When I press "Yes" within "main"
        Then I should see "Verification successful"
        When I follow "Go back"
        Then I should be on the homepage
        When I follow "Admin" within "header"
        Then I should see "Approve New Users"
        When I follow "Approve New Users"
        Then I should not see "Testing Unapproved User"
        Then I should not see "role1"
        Then I should see "TestingRole2"
        Then I should see "role2"
        Then I should see "Customer Service"
    
    Scenario: Admin approves role 2
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "admin" within "section"
        When I fill in "user-password" with "admin" within "section"
        When I press "submit-login" within "section"
        Then I should be on the homepage
        When I follow "Admin" within "header"
        Then I should see "Approve New Users"
        When I follow "Approve New Users"
        Then I should see "TestingRole2"
        Then I should see "role2"
        Then I should see "Customer Service"
        When I click "#verify-user4"
        Then I should see "Are you sure you verify this user and grant them access to the system?"
        When I press "Yes" within "main"
        Then I should see "Verification successful"
        When I follow "Go back"
        Then I should be on the homepage
        When I follow "Admin" within "header"
        Then I should see "Approve New Users"
        When I follow "Approve New Users"
        Then I should not see "Testing Unapproved User"
        Then I should not see "role1"
        Then I should not see "TestingRole2"
        Then I should not see "role2"
        Then I should not see "Customer Service"
