require 'bcrypt'
require_relative 'database-model.rb'
require_relative '../user-authentication.rb'

def getErrorMessage params

    error_msg = ""

    email = params[:email]
    email_conf = params[:email_validation]
    if ! isValidEmail email
        error_msg += "Please enter valid email <br>"
    elsif email != email_conf
        error_msg += "Emails don't match <br>"
    elsif ! Bookmarks.isUniqueValue "users", "user_email", email
        error_msg += "Email already in use <br>"
    end

    password = params[:password]
    password_conf = params[:password_validation]
    if ! isValidPassword password
        error_msg += "Please enter valid password <br>"
    elsif password != password_conf
        error_msg += "Passwords don't match<br>"
    end

    return error_msg

end

def isValidEmail email
    return !email.nil? && (email.index URI::MailTo::EMAIL_REGEXP)
end

def isValidPassword password
    return (!password.nil?) && (password.length>=8) && !(password.index /\d/).nil? && !(password.index /[\#\?\!\@\$\%\^\&\*\-\_]/).nil? && (password.index /\s/).nil?
end

def newUser displayName, email, password
    return Bookmarks.addRegisterDetails email, displayName, nil, password
end

def newReport bookmarkId, reporterId, type, desc
    return Bookmarks.addReport bookmarkId, type, desc, reporterId, Time.now.strftime("%d/%m/%Y")
end

def addView bookmarkId, userId
    Bookmarks.addView userId.to_i, bookmarkId.to_i, Time.now.strftime("%d/%m/%Y")
end

def newBookmark userID, title, link, desc
    title = nil if title == ""
    link = nil if link == ""
    desc = nil if desc == ""

    return Bookmarks.addBookmark title, desc, link, userID,  Time.now.strftime("%d/%m/%Y")
end

def extractTagsFromParams params 
    if params
        number = params[:numOfTags].to_i
        tags = []
        (0..(number-1)).each do |i|
            tags << params[("tagNo#{i}").to_sym]
        end
        return tags
    end
    return ""
end

puts (isValidPassword "password44_")