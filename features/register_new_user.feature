Feature: register new user
    Scenario: register user with new email and new name.
        Given I am on the homepage.
        When I click "Register" within "header"
        When I fill in the following:
            |Display name|"Added By Testing User"|
            |Email|"addnew@user.com"|
            |Confirm email|"addnew@user.com"|
            |Password|"addnew@user.com"|
            |Confirm password|"addnew@user.com"|
        When I press "Create" within "form"
        Then I should see "Thank you for registration in our system. Your aplication is now being processed. In the meantime you can view and report bookmarks as well as view your profile details." within "h4"