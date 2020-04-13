require 'sqlite3'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'

module UserAuthentication
    DATABASE = ""
    TABLE = 'users'
    
    def UserAuthentication.check(email,password)
        # checks password against hashed/salted value in db
        # returns userID if passwords match, -1 otherwise
        validUser = false
        queryResult = Bookmarks.getDetailsByEmail(email)
        if queryResult
            userID = queryResult[:id]
            hashCheck = BCrypt::Password.new(queryResult[:password])
            validUser = hashCheck.is_password?(password)
        end
        
        if validUser then
            if queryResult[:suspended].to_i == 1
                return "Suspended"
            elsif queryResult[:type] == Bookmarks::UNVERIFIED_STRING
                return "Unverified"
            else
                return userID
            end
        else
            return -1
        end
    end   
end