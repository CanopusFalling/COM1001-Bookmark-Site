Feature: register new user
    Scenario: register user with valid credentials.
        Given I am on the homepage.
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word!" within "section"
        When I fill in "confirm-user-password" with "NewUserPa55word!" within "section"
        When I press "register-user" within "section"
        Then I should see "Thank you for registration in our system. Your aplication is now being processed. In the meantime you can view and report bookmarks as well as view your profile details." within "main"