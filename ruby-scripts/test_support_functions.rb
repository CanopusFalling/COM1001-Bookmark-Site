require 'minitest/autorun'
require_relative 'database-model.rb'
require_relative 'support-functions.rb'
require_relative 'deployment-scripts.rb'

class TestSupportFunctions < Minitest::Test
    Bookmarks.init('../database/test.db')
    Deployment.resetDatabase
    Deployment.testData

    def test_error_message 
        validEmail = "email@email.com"
        email2 = "email2@email.com"
        invalidEmail = "email"
        validPassword1 = "password@1"
        validPassword2 = "password@@2"
        invalidPassword = "passw1"

        # error messages for emails
        #assert_equal getErrorMessage({:email => validEmail, :email_validation => validEmail, :password => validPassword1,
            #:password_validation => validPassword1}), ""
        assert_equal getErrorMessage({:email => invalidEmail, :email_validation => invalidEmail, :password => validPassword1,
            :password_validation => validPassword1}), "Please enter valid email <br>"
        assert_equal getErrorMessage({:email => validEmail, :email_validation => email2, :password => validPassword1,
            :password_validation => validPassword1}), "Emails don't match <br>"
    end

    def test_password_error 
        validPassword1 = "password@1"
        validPassword2 = "password@@2"
        invalidPassword = "passw1"

        assert_equal getPasswordErrorMsg({:password => validPassword1,:password_validation => validPassword1}), ""
        assert_equal getPasswordErrorMsg({:password => validPassword1,:password_validation => validPassword2}), "Passwords don't match"
        assert_equal getPasswordErrorMsg({:password => invalidPassword,:password_validation => invalidPassword}),"Please enter valid password\n"
    end

    def test_isValidEmail 
        validEmail = "email@email.com"
        validEmail2 = "email2@email.com"
        invalidEmail = "email"

        assert isValidEmail(validEmail)
        assert isValidEmail(validEmail2)
        refute isValidEmail(invalidEmail)
    end

    def test_isValidPassword
        validPassword1 = "password@1"
        validPassword2 = "password@@2"
        invalidPassword = "passw1"

        assert isValidPassword(validPassword1)
        assert isValidPassword(validPassword2)
        refute isValidPassword(invalidPassword)
    end

    def test_newUser
        assert newUser("user01","email@email.com","password@1")
        assert newUser("user50","g@gmail.com","password##5")
        
        refute newUser("user60","role2","password##5")
        refute newUser("user70",nil,"password$$3")
    end

    def test_newReport
        assert newReport(1,1,"broken link","wrong page")
        assert newReport(1,1,"source unreliable","don't use this website")

        refute newReport('a',1,"broken link","wrong page")
        refute newReport(2,"a","broken link","wrong page")
        refute newReport(nil,1,"broken link","wrong page")
        refute newReport(100,1,"broken link","wrong page")
        refute newReport(1,1000,"broken link","wrong page")
    end

    def test_addView
        assert addView(1,1)
        assert addView(2,2)

        refute addView(nil,1)
        refute addView(1,nil)
        refute addView(100,2)
        refute addView(1,1000)
    end

    def test_addRating
        assert addRating(1,3,5)
        assert addRating(1,4,1)

        refute addRating("X",3,5)
        refute addRating(4,"X",5)
        refute addRating(1,2,"X")
        refute addRating(nil,2,2)
        refute addRating(4,nil,3)
        refute addRating(5,3,nil)
        refute addRating(10,3,-1)
        refute addRating(10,3,8)
    end

    def test_changeRating
        assert changeRating(1,1,3)
        assert changeRating(2,1,1)

        refute changeRating("a",1,1)
        refute changeRating(1,"x",5)
    end

    def test_addComment
        assert addComment(1,1,"Nice")
        assert addComment(2,2,"decent")

        refute addComment("x",1,"nice")
        refute addComment(2,"a","nice")
        refute addComment(nil,1,"nice")
        refute addComment(2,nil,"nice")
        refute addComment(1000,1,"nice")
        refute addComment(2,1000,"nice")
    end

    def test_deleteBookmark
        assert deleteBookmark(11)
        assert deleteBookmark(12)

        refute deleteBookmark("ten")
        refute deleteBookmark("five")
    end

    def test_updateBookmark
        assert updateBookmark(7,"Tree","tree.com","",1)
        assert updateBookmark(8,"reddit","reddit.com","",2)

        refute updateBookmark(10,nil,"twitter.com","",3)
        refute updateBookmark(10,"Twitter",nil,"",3)
    end
end 