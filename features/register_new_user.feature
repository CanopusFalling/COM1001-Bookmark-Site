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

    Scenario: Register user with the same email address as the previous user.
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word!" within "section"
        When I fill in "confirm-user-password" with "NewUserPa55word!" within "section"
        When I press "register-user" within "section"
        Then I should see "Email already in use" within "main"

    Scenario: Register user with the same display name as the previous user.
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew2@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew2@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word2!" within "section"
        When I fill in "confirm-user-password" with "NewUserPa55word2!" within "section"
        When I press "register-user" within "section"
        Then I should see "Thank you for registration in our system. Your aplication is now being processed. In the meantime you can view and report bookmarks as well as view your profile details." within "main"

    Scenario: Register user with the same password as the previous user.
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew3@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew3@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word2!" within "section"
        When I fill in "confirm-user-password" with "NewUserPa55word2!" within "section"
        When I press "register-user" within "section"
        Then I should see "Thank you for registration in our system. Your aplication is now being processed. In the meantime you can view and report bookmarks as well as view your profile details." within "main"

    Scenario: Register user with invalid password (Not long enough).
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew4@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew4@user.com" within "section"
        When I fill in "user-password" with "1!" within "section"
        When I fill in "confirm-user-password" with "1!" within "section"
        When I press "register-user" within "section"
        Then I should see "Display name:" within "main"

    Scenario: Register user with invalid password (No number).
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew4@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew4@user.com" within "section"
        When I fill in "user-password" with "TestingPassword!" within "section"
        When I fill in "confirm-user-password" with "TestingPassword!" within "section"
        When I press "register-user" within "section"
        Then I should see "Please enter valid password" within "main"

    Scenario: Register user with invalid password (No special char).
        Given I am on the homepage
        When I follow "Register" within "header"
        When I fill in "display-name" with "Added By Testing User" within "section"
        When I fill in "user-email" with "addnew4@user.com" within "section"
        When I fill in "confirm-user-email" with "addnew4@user.com" within "section"
        When I fill in "user-password" with "TestingPassword1" within "section"
        When I fill in "confirm-user-password" with "TestingPassword1" within "section"
        When I press "register-user" within "section"
        Then I should see "Please enter valid password" within "main"

    Scenario: Log in as new user.
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "addnew@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word!" within "section"
        When I press "submit-login" within "section"
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"

    Scenario: Attempt to make bookmark as an unverified user.
        Given I am on the homepage
        When I follow "Login" within "header"
        When I fill in "user-email" with "addnew@user.com" within "section"
        When I fill in "user-password" with "NewUserPa55word!" within "section"
        When I press "submit-login" within "section"
        Then I should see "Profile" within "header"
        Then I should see "Create Bookmark" within "header"
        Then I should not see "Login" within "header"
        Then I should not see "Register" within "header"
        When I follow "Create Bookmark" within "header"
        Then I should see "This option is unavailable, because your account hasn't been verified. Please wait for your manager to verify your account."
        When I follow "Go back" within "main"
        Then I should be on the homepage