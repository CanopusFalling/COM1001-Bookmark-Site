require 'sqlite3'
require 'bcrypt'
require_relative 'database-model.rb'

module UserAuthentication
    DATABASE = ""
    TABLE = 'users'

    # checks password against hashed/salted value in db
    # returns userID if passwords match, -1 otherwise
    def UserAuthentication.check(email,password)
        validUser = false
        queryResult = Bookmarks.getDetailsByEmail(email)
        if queryResult
            userID = queryResult[:id]
            hashCheck = BCrypt::Password.new(queryResult[:password])
            validUser = hashCheck.is_password?(password)
        end
        
        if validUser then
                return userID
        else
            return -1
        end
    end   

    def UserAuthentication.hasPasswordReset(email)
        hasReset = false
        queryResult = Bookmarks.getDetailsByEmail(email)
        if queryResult
            hashCheck = BCrypt::Password.new(queryResult[:password])
            validUser = hashCheck.is_password?("password")
        end

        if validUser then 
            return true
        else
            return false
        end
    end


    def UserAuthentication.hasEditRights bookmarkId, userId

        if ((UserAuthentication.getAccessLevel userId) == 0)
            return false
        elsif (((Bookmarks.getBookmarkCreator bookmarkId.to_i) == userId) || ((UserAuthentication.getAccessLevel userId) == 2))
            return true
        else
            return false
        end

    end

    # 0 for guest, unverified or suspended user, 1 for active user,2 for admin
    def UserAuthentication.getAccessLevel userID
        if userID == -1 || !(Bookmarks.resourceExists? userID, "users")
            return 0
        else
            user = Bookmarks.getAccessDetails userID
            if user[:user_suspended] == 1 || user[:user_type] == Bookmarks::UNVERIFIED_STRING
                
                return 0
            elsif user[:user_type] == Bookmarks::USER_STRING
                return 1
            elsif user[:user_type] == Bookmarks::ADMIN_STRING
                return 2
            else
                return 0
            end
        end
    end

        
end


        