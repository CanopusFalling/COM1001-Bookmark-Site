require 'bcrypt'
require_relative 'database-model.rb'
require_relative 'user-authentication.rb'

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

def getPasswordErrorMsg params
    error_msg = ""
    password = params[:password]
    password_conf = params[:password_validation]
    if ! isValidPassword password
        error_msg += "Please enter valid password"
        error_msg += "\n"
    elsif password != password_conf
        error_msg += "Passwords don't match"
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
    return Bookmarks.addReport bookmarkId.to_i, type, desc, reporterId.to_i, Time.now.strftime("%d/%m/%Y")
end

def addView bookmarkId, userId
    Bookmarks.addView userId.to_i, bookmarkId.to_i, Time.now.strftime("%d/%m/%Y")
end

def addRating bookmarkID, userID, value 
    return Bookmarks.addRating bookmarkID, userID, value.to_i, Time.now.strftime("%d/%m/%Y")
end 

def changeRating bookmarkID, userID, value
    return Bookmarks.changeRating bookmarkID, userID, value.to_i, Time.now.strftime("%d/%m/%Y")
end 

def addComment bookmarkID, userID, comment
    return Bookmarks.addComment bookmarkID, userID, comment, Time.now.strftime("%d/%m/%Y")
end

def deleteComment commentID
    return Bookmarks.deleteComment commentID, Time.now.strftime("%d/%m/%Y")
end
def newBookmark userID, title, link, desc
    title = nil if title == ""
    link = nil if link == ""
    desc = nil if desc == ""

    return Bookmarks.addBookmark title, desc, link, Time.now.strftime("%d/%m/%Y"), userID
end

def deleteBookmark bookmarkID
    return Bookmarks.deleteBookmark(bookmarkID)
end

def extractTagsFromParams params 
    if params
        number = params[:numOfTags].to_i
        currentTags = Bookmarks.getTagNames
        tags = []
        (0..(number-1)).each do |i|
            tag = params[("tagNo#{i}").to_sym]
            Bookmarks.addTag tag, "rgba(0,0,0,255)", Time.now.strftime("%d/%m/%Y") if (!currentTags.include? tag)
            tags << tag
        end
        return tags
    end
    return Array.new
end

def assignTags tags, bookmarkId
    tags.each do |name|
        tagId = Bookmarks.getTagId name
        Bookmarks.addTagBookmarkLink tagId.to_i, bookmarkId.to_i
    end

end

def reAssignTags newTags, currentTags, bookmarkId   

    currentTags.each do |name|
        if !newTags.include? name
            tagId = Bookmarks.getTagId name
            Bookmarks.deleteTagBookmarkLink tagId.to_i, bookmarkId.to_i
        end
    end

    newTags.each do |name|
        if !currentTags.include? name
            tagId = Bookmarks.getTagId name
            Bookmarks.addTagBookmarkLink tagId.to_i, bookmarkId.to_i
        end
    end
end

def h(text)
    Rack::Utils.escape_html(text)
end

def filterAgainstTags bookmarks, tags
    if !tags || tags.length == 0
        return bookmarks
    end
    result = Array.new
    bookmarks.each do |bookmark|
        result<<bookmark if (intersection((Bookmarks.getBookmarkTagsNames bookmark[:ID].to_i), tags).length > 0)
    end

    return result
end

def updateBookmark bookmarkId, title, link, desc, userId

    title = nil if title == ""
    link = nil if link == ""
    desc = nil if desc == ""
    Bookmarks.addBookmarkEdit userId, bookmarkId, Time.now.strftime("%d/%m/%Y")
    return Bookmarks.updateBookmark bookmarkId, title, desc, link

end

def intersection a, b

    result = Array.new
    a.each do |element|
        result << element if b.include? element
    end

    return result
end
