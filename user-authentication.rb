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
        queryResult = Bookmarks.getPasswordHash(email)
        userID = queryResult[0][0]
        hashCheck = BCrypt::Password.new(queryResult[0][1])
        validUser = hashCheck.is_password?(password)
        if validUser then
            return userID
        else
            return -1
        end
    end   
end