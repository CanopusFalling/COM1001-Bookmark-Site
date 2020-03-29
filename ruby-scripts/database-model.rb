require 'sqlite3'
require 'bcrypt'

module Bookmarks
    
    #===Constants declaration
    UNVERIFIED_STRING = "Unverified"
    USER_STRING = "User"
    ADMIN_STRING = "Admin"
    #===Setup methods===

    #Run to open the database connection
    
    def Bookmarks.init databaseDirectory
        @@db = SQLite3::Database.open File.join(File.dirname(__FILE__), databaseDirectory)
        @@db.results_as_hash = true
    end 

    #===Queries methods===

    #Retursns list of bookmarks with titles containing param search
    #Params: search - what to look for in target titles
    #Returns: A array of hashes with following keys (or nil if input was incorrect): 
    #   :ID - id of a bookmark
    #   :title - title of a bookmark
    #   :rating - avg rating of a bookmark (nil if no ratings)
    #   :views - total view count of a bookmark
    def Bookmarks.getHomepageData search
        result = nil
        if search
            query = "SELECT * FROM bookmark_list
                    WHERE title LIKE ?;"  
            result = @@db.execute query, "%#{search}%"
            result.map{|row| row.transform_keys!(&:to_sym)}
        end
        return result
    end

    #Returns list of all bookmarks 
    #Returns: A array of hashes with following keys: 
    #   :ID - id of a bookmark
    #   :title - title of a bookmark
    #   :rating - avg rating of a bookmark (nil if no ratings)
    #   :views - total view count of a bookmark
    def Bookmarks.getHomepageDataAll
        return Bookmarks.getHomepageData ""
    end

    #Returns: An array of distinct user emails(strings)
    def Bookmarks.currentUserEmails
        query = "SELECT DISTINCT user_email AS email
                FROM users;"
        result = @@db.execute query
        (0..(result.length()-1)).each do |i|
            result[i] = result[i]["email"]
        end
        return result
    end

    #Given an email returns id and password hash of a given user
    #Params: email - an email of a current user
    #Returns: A hash with following keys (or nil if input was incorrect):
    #   :id - user id
    #   :password - user password's hash
    def Bookmarks.getPasswordHash email
        result = nil
        if email
            query = "SELECT 
                    user_id AS id,
                    user_password AS password
                    FROM users
                    WHERE user_email=?;"
            result = @@db.execute query,email

            if result.length > 0
                result = result[0]
                result.transform_keys!(&:to_sym)
            else
                result = nil
            end
        end
        return result
    end

    #Returns details of a bookmark when viewed by a guest
    #Params: id (integer) - an id of a bookmark in current system
    #Returns: A hash with following keys:
    #   :details - A hash with following keys (or nil if input was incorrect):
    #       :ID - id of a bookmark
    #       :title - title of a bookmark
    #       :description - description of a bookmark
    #       :link - link of a bookmark
    #       :date - date of creation of a bookmark
    #       :email - email of an autor of a bookmark
    #       :displayName - display name of an author of a bookmark
    #   :tags - An array of hashes with following keys (or nil if input wasn't an integer):
    #       :name - name of a tag the bookmark is tagged with
    #       :colour - coulour of a tag the bookmark is tagged with
    def Bookmarks.getGuestBookmarkDetails id
        
        result = Hash.new
        result[:details] = nil
        result[:tags] = nil
       
        if id.is_a? Integer

            query = "SELECT 
            bookmark_ID AS ID,
            bookmark_title AS title,
            bookmark_description AS description,
            bookmark_link AS link,
            date_created AS date,
            user_email AS email,
            user_displayName AS displayName
            FROM bookmark JOIN users ON creator_ID = user_ID
            WHERE bookmark_ID = ?;"

            result[:details] = @@db.execute query , id.to_i

            if result[:details].length() >0
                result[:details] = result[:details][0]
                result[:details].transform_keys!(&:to_sym)
            else
                result[:details] = nil
            end

            query = "SELECT 
                    tag_name AS name,
                    tag_colour AS colour
                    FROM tag_bookmark_link JOIN tag USING(tag_ID)
                    WHERE bookmark_ID = ?;"
            result[:tags] = @@db.execute query, id.to_i
            result[:tags].map{|row| row.transform_keys!(&:to_sym)}
            
        end

        return result
    end

    #Returns value the user rated the bookmark with
    #Params:
    #   bookmark_id - an id of a bookmark in current system
    #   user_id - an id of a user viewing the bookmark
    #Returns: a value the user rated bookmark with 
    #         or nil if the bookmark hasn't been rated yet or input was incorrect
    def Bookmarks.isRated bookmark_ID, user_ID
        if (bookmark_ID.is_a? Integer) && (user_ID.is_a? Integer)
            query = "SELECT rating_value
                    FROM rating
                    WHERE bookmark_ID = ? AND rater_ID = ?"
            value = @@db.get_first_value query , bookmark_ID.to_i, user_ID.to_i
            value = value.to_i if !value.nil?
            return value;
        end
        return nil
    end

    #Returns true if giben bookmark was liked by the user and false if not
    #Params:
    #   bookmark_id - an id of a bookmark in current system
    #   user_id - an id of a user viewing the bookmark
    def Bookmarks.isLiked bookmark_ID, user_ID
        if (user_ID.is_a? Integer) && (bookmark_ID.is_a? Integer)
                query = "SELECT * FROM favourite
                WHERE user_ID = ? AND bookmark_ID = ?;"
                rows = @@db.execute query,user_ID.to_i,user_ID.to_i
                if(rows.length() == 0) 
                    return false
                else     
                   return true
                end
        end
        return nil
    end

    #Returns details of a bookmark when viewed by a user
    #Params: 
    #   bookmark_id (integer) - an id of a bookmark in current system
    #   user_id (integer) - an id of a user viewing the bookmark
    #Returns: A hash with following keys:
    #   :details - A hash with following keys (or nil if input was incorrect):
    #       :ID - id of a bookmark
    #       :title - title of a bookmark
    #       :description - description of a bookmark
    #       :link - link of a bookmark
    #       :date - date of creation of a bookmark
    #       :email - email of an autor of a bookmark
    #       :displayName - display name of an author of a bookmark
    #   :tags - An array of hashes with following keys (or nil if input wasn't an integer):
    #       :name - name of a tag the bookmark is tagged with
    #       :colour - coulour of a tag the bookmark is tagged with
    #   :comments - An array of hashes with following keys (or nil if input wasn't an integer):
    #       :details - a comment itself
    #       :created - a date of creation
    #       :deleted - adate of deletion
    #       :email - email af an author
    #       :displayName - display name of an author
    #   :liked (boolean) - is this bookmark on user's favourite list 
    #   :rating - a value the user rated bookmark with (nil if not rated yet or incorrect input)
    def Bookmarks.getBookmarkDetails (bookmark_ID,user_ID)
            
        details = Bookmarks.getGuestBookmarkDetails bookmark_ID
        result = Hash.new
        result[:details] = details[:details]
        result[:tags] = details[:tags]
        result[:comments] = []
        result[:liked] = nil
        result[:rating] = nil
        if bookmark_ID.is_a? Integer
            query = "SELECT 
            comment_details AS details,
            date_created AS created,
            date_deleted AS deleted,
            user_email AS email,
            user_displayName AS displayName
            FROM comment JOIN users ON commenter_ID = user_ID
            WHERE bookmark_ID = ?;"
            result[:comments] = @@db.execute query,bookmark_ID.to_i
            result[:comments].map{|row| row.transform_keys!(&:to_sym)}
            
            result[:liked] = Bookmarks.isLiked bookmark_ID, user_ID 

            result[:rating] = Bookmarks.isRated bookmark_ID, user_ID

        end

        return result
    end

    #Returns: An array with all the tag names
    def Bookmarks.getTagNames
        query = "SELECT tag_name FROM tag";
        result = @@db.execute query
        (0..(result.length()-1)).each do |i|
            result[i] = result[i]["tag_name"]
        end

        return result
    end

    #Returns details of a user with given id
    #Params: id(integer) - an id of a user 
    #Returns: A hash containing with following keys (or nil if input was incorrect):
    #   :name - display name of a user
    #   :email - email of a user
    #   :department - department of a user
    def Bookmarks.getUserDetails id
        result = nil
        if id.is_a? Integer
            query = "SELECT user_displayName AS name,
                    user_email AS email,
                    user_department AS department
                    FROM users
                    WHERE user_ID = ?;"
            result = @@db.execute query, id.to_i

            if(result.length()>0)
                result = result[0]
                result.transform_keys!(&:to_sym)
            else
                result = nil
            end
        end
        
        return result
    end

    #Returns list of bookmarks on given users favourite list
    #Params: id (integer) - id of a given user
    #Returns: An array of hashes with following keys (or nil if input was incorrect): 
    #   :ID - id of a bookmark
    #   :title - title of a bookmark
    #   :rating - avg rating of a bookmark (nil if no ratings)
    #   :views - total view count of a bookmark
    def Bookmarks.getFavouriteList id
        result = nil
        if id.is_a? Integer
            query = "SELECT ID, title, rating, views 
                    FROM favourite JOIN bookmark_list ON bookmark_ID = ID
                    WHERE user_ID = ?;"
            result = @@db.execute query,id.to_i
            result.map{|row| row.transform_keys!(&:to_sym)}
        end

        return result
    end

    #Returns a list of users waiting for verification
    #Returns: An array of hashes with following keys:
    #   :ID - id of a user
    #   :email - email of a user 
    #   :displayName - display name of a user
    #   :department - department of a user
    def Bookmarks.getUnverifiedList 
        query = "SELECT 
                user_ID AS ID,
                user_email AS email,
                user_displayName as displayName,
                user_department as department
                FROM users
                WHERE user_type = ?;"
        result = @@db.execute query, UNVERIFIED_STRING
        result.map{|row| row.transform_keys!(&:to_sym)}
        
        return result
    end
    
    #Returns a list of users already verified
    #Returns: An array of hashes with following keys:
    #   :ID - id of a user
    #   :email - email of a user 
    #   :displayName - display name of a user
    #   :department - department of a user
    #   :status - type of user perrmisons
    #   :suspended - is the usersuspended
    def Bookmarks.getVerifiedList
        query = "SELECT 
                user_ID AS ID,
                user_email AS email,
                user_displayName AS displayName,
                user_department AS department,
                user_type AS status,
                user_suspended AS suspended
                FROM users
                WHERE NOT user_type = ?;"
        result = @@db.execute query, UNVERIFIED_STRING
        result.map{|row| row.transform_keys!(&:to_sym)}

        return result
    end
    
    #Returns true if given id was verified and false if not (or nil if input was incorrect)
    def Bookmarks.isVerified userID
        if userID.is_a? Integer
            query = "SELECT user_type
                    FROM users
                    WHERE user_ID = ?;"
            result = @@db.get_first_value query, userID
            if result != UNVERIFIED_STRING
                return true
            else
                return false
            end
        else
            return nil
        end
    end

    #Returns true if given id was verified and false if not (or nil if input was incorrect)
    def Bookmarks.isVerified userID
        if userID.is_a? Integer
            query = "SELECT user_type
                    FROM users
                    WHERE user_ID = ?;"
            result = @@db.get_first_value query, userID
            if result != UNVERIFIED_STRING
                return true
            else
                return false
            end
        else
            return nil
        end
    end

    #Returns a viewing history of specified user
    #Params: id (integer) - is of the specified user
    #Returns: An array of hashes with following keys (or nil if input was incorrect):
    #   :bookmark_ID - id of a bookmark viewed
    #   :date - when was the bookmark viewed
    def Bookmarks.getViewHistory id
        result = nil
        if id.is_a? Integer
            query = "SELECT
                    bookmark_viewed_ID AS bookmark_ID,
                    view_date AS date
                    FROM views
                    WHERE viewer_ID = ?;"
            result = @@db.execute query, id.to_i
            result.map{|row| row.transform_keys!(&:to_sym)}
        end

        return result
    end

    #Returns a list of unresolved reports
    #Returns: An array of hashes with following keys:
    #   :bookmark_ID - id of a bookmark reported 
    #   :title - title of a bookmark
    #   :rating - avg rating of a bookmark  (nil if no ratings)
    #   :views - total view count of a bookmark

    def Bookmarks.getUnresolvedReports
        query = "SELECT 
                ID,
                title,
                rating,
                views
                FROM bookmark_list JOIN(
                    SELECT DISTINCT bookmark_ID
                    FROM report
                    WHERE report_resolved = 0
                ) ON ID = bookmark_ID;"
        result = @@db.execute query
        result.map{|row| row.transform_keys!(&:to_sym)}
                    
        return result
    end

    #Returns details of a reported bookmark
    #Params: id (integer) - an id of a specified bookmark
    #Returns: A hash with following keys (or nil if the input was incorrect):
    #   :title - title of a bookmark
    #   :link - link of a bookmark
    #   :report_type - a type of the report
    #   :details - details of the report
    def Bookmarks.getReportedBookmarkDetails id
        result = nil
        if id.is_a? Integer
            query = "SELECT 
                    bookmark_title AS title,
                    bookmark_link AS link,
                    report_type AS report_type,
                    report_details AS details
                    FROM bookmark JOIN report USING(bookmark_ID)
                    WHERE bookmark_ID = ?;"
            result = @@db.execute query,id
            result.map{|row| row.transform_keys!(&:to_sym)}
        end

        return result
    end
    
    #Returns table names in current database in an array
    def Bookmarks.getTableNames
        query = "SELECT 
                name
                FROM sqlite_master 
                WHERE type ='table' AND name NOT LIKE 'sqlite_%';"
        result = @@db.execute query
        
        (0..(result.length()-1)).each do |i|
            result[i]=result[i]["name"]
        end

        return result
    end

    #Returns column names given table in an array
    def Bookmarks.getColumnNames tableName
        if Bookmarks.getTableNames.include? tableName

            query = "PRAGMA table_info ('#{tableName}');"
            result = @@db.execute query

            (0..(result.length()-1)).each do |i|
                result[i]=result[i]["name"]
            end

            return result
        end
        return Array.new
    end

    #Checks if value passed exists in a database
    #Params tableName - name of the table in which to look for uniqness
    #       columnName - name of the column in which to check uniqness
    #       value - value to be looked for
    #Returns: true - if value doesn't exist in a given column in given table
    #         false - if it does
    #         nil -if given column or table name are incorrect
    def Bookmarks.isUniqueValue tableName , columnName , value
        if (Bookmarks.getColumnNames tableName).include? columnName
            query = "SELECT DISTINCT #{columnName}
                     FROM #{tableName} ;"
            result = @@db.execute query
            
            (0..(result.length()-1)).each do |i|
                if result[i][columnName] == value
                    return false
                end
            end
            return true

        end
        return nil
    end 

    # Returns true if the value is an integer
    def Bookmarks.isInteger value
        return value.is_a? Integer
    end 
    
    # Returns true if value is null
    def Bookmarks.isNull value
        if value == nil  then
            return true
        else 
            return false
        end
    end

    # Checks if value is outside of range of ID's in table
    # Params id - value to being checked
    # columnName - column where ID's are stored
    # tableName - table of ID being checked
    # Returns true - if 'id' is outside of the range
    #         false - if 'id' is within the range

    def Bookmarks.idOutOfRange id, columnName, tableName
        query = "SELECT DISTINCT #{columnName}
                     FROM #{tableName} ;"
        result = @@db.execute query

        largest = 0
        (0..(result.length()-1)).each do |i|
            if result[i][0] > largest then
                largest = result[i][0]
            end
        end

        if id > largest || id < 0 then
            return true
        else
            return false
        end
    end

    # === Insert Methods ========

    
    # Insert user's details into db when they register an account
    def Bookmarks.addRegisterDetails (uEmail, uDisplay, uDepartment, password)
        if !Bookmarks.isUniqueValue('users','user_email',uEmail) then
            return false
         
        elsif Bookmarks.isNull(uEmail) then
            return false         
        else
            query = "INSERT INTO users(user_email, user_displayName, user_department,
                    user_password, user_type, user_suspended)
                    VALUES (?, ?, ?, ?, ?, ?);"
            @@db.execute query, uEmail, uDisplay, uDepartment,BCrypt::Password.create(password),USER_STRING,0
            return true
        end 
    end
    # Insert admin user's details when registering account
    def Bookmarks.addAdminUser(uEmail, uDisplay, uDepartment, password)
        if !Bookmarks.isUniqueValue('users','user_email',uEmail) then
            return false
         
        elsif Bookmarks.isNull(uEmail) then
            return false         
        else
            query = "INSERT INTO users(user_email, user_displayName, user_department,
                                    user_password, user_type, user_suspended)
                    VALUES (?, ?, ?, ?, ?,?);"
            @@db.execute query, uEmail, uDisplay, uDepartment,BCrypt::Password.create(password),ADMIN_STRING,0
            return true
        end
    end 
    
    # Add bookmark details to the db
    def Bookmarks.addBookmark (bookmarkTitle, bookmarkDesc, bookmarkLink, bookmarkCreationDate, creatorID)
        if !Bookmarks.isUniqueValue('bookmark','bookmark_link', bookmarkLink) then
            return false      
        elsif Bookmarks.isNull(bookmarkTitle) then
            return false
        elsif Bookmarks.idOutOfRange(creatorID,'user_ID','users') && creatorID != nil then
            return false
        else
            query = "INSERT INTO bookmark(bookmark_title, bookmark_description, bookmark_link, date_created,
                                        creator_ID)
                    VALUES (?, ?, ?, ?, ?);"
            @@db.execute query, bookmarkTitle, bookmarkDesc, bookmarkLink, bookmarkCreationDate, creatorID
            return true
        end
    end
    
    # Adding details of edit made to bookmark
    def Bookmarks.addBookmarkEdit(editor, bookmark, editDate)
        if !Bookmarks.isInteger(editor) || !Bookmarks.isInteger(bookmark) then
            return false 
        elsif Bookmarks.isNull(editor) || Bookmarks.isNull(bookmark) then
            return false
        elsif Bookmarks.idOutOfRange(editor,'user_ID','users') || Bookmarks.idOutOfRange(bookmark,'bookmark_ID','bookmark') then
            return false
        else
            query = "INSERT INTO edit(editor_ID, bookmark_edited_ID, edit_date)
                    VALUES(?,?,?);"
            @@db.execute query, editor, bookmark, editDate
            return true
        end
    end
    
    # Add comment details to db
    def Bookmarks.addComment(bookmark, commenter, details, dateCreated)
        if !Bookmarks.isInteger(bookmark) || !Bookmarks.isInteger(commenter) then
            return false
        elsif Bookmarks.isNull(bookmark) || Bookmarks.isNull(commenter) then
            return false
        elsif Bookmarks.idOutOfRange(bookmark,'bookmark_ID','bookmark') || Bookmarks.idOutOfRange(commenter,'user_ID','users') then
            return false
        else
            query = "INSERT INTO comment(bookmark_ID, commenter_ID, comment_details, date_created)
                    VALUES(?,?,?,?);"
            @@db.execute query, bookmark, commenter, details, dateCreated
            return true
        end
    end
    
    # Add details of favourite into db
    def Bookmarks.addFavourite(user,bookmark)
        if !Bookmarks.isInteger(user) || !Bookmarks.isInteger(bookmark) then
            return false
        elsif Bookmarks.isNull(user) || Bookmarks.isNull(bookmark) then
            return false
        elsif Bookmarks.idOutOfRange(user,'user_ID','users') || Bookmarks.idOutOfRange(bookmark,'bookmark_ID','bookmark') then
            return false
        else
            query = "INSERT INTO favourite(user_ID,bookmark_ID)
                    VALUES(?,?);"
            @@db.execute query, user, bookmark
            return true
        end
    end
    
    # Adds details of a rating to the db
    def Bookmarks.addRating(bookmark, rater, value, dateCreated)
        if !Bookmarks.isInteger(bookmark) || !Bookmarks.isInteger(rater) || !Bookmarks.isInteger(value) then
            return false
        elsif Bookmarks.isNull(bookmark) || Bookmarks.isNull(rater) || Bookmarks.isNull(value) then
            return false
        elsif  Bookmarks.idOutOfRange(bookmark,'bookmark_ID','bookmark') || Bookmarks.idOutOfRange(rater,'user_ID','users') then
            return false
        elsif value < 1 || value > 5 then
            return false
        else
            query = "INSERT INTO rating(bookmark_ID, rater_ID, rating_value, rating_created)
                    VALUES(?,?,?,?);"
            @@db.execute query, bookmark, rater, value, dateCreated
            return true
        end
    end
    
    # Add details of a report to the db
    def Bookmarks.addReport (reportedPageID, reportType, reportDetails, reporterID, reportDate)
        if !Bookmarks.isInteger(reportedPageID) or !Bookmarks.isInteger(reporterID) then
            return false
        elsif Bookmarks.isNull(reportedPageID) then
            return false
        elsif Bookmarks.idOutOfRange(reportedPageID,'bookmark_ID','bookmark') || Bookmarks.idOutOfRange(reporterID,'user_id','users') then
            return false
        else
            query = "INSERT INTO report(bookmark_ID, report_type, report_details, 
                                        reporter_ID, report_date,report_resolved)
                    VALUES (?, ?, ?, ?, ?, ?);"
            @@db.execute query, reportedPageID, reportType, reportDetails, reporterID, reportDate, 0
            return true
        end
    end
    
    # Adds tag to db
    def Bookmarks.addTag(name, colour, dateCreated)
        if !Bookmarks.isNull(name) then
            query = "INSERT INTO tag(tag_name, tag_colour, tag_date_created)
                    VALUES(?,?,?);"
            @@db.execute query, name, colour, dateCreated
            return true
        else
            return false
        end
    end
    
    # Add tag and bookmark ID's to the linking table
    def Bookmarks.addTagBookmarkLink(tag, bookmark)
        if !Bookmarks.isInteger(tag) or !Bookmarks.isInteger(bookmark) then
            return false
        elsif Bookmarks.isNull(tag) or Bookmarks.isNull(bookmark) then
            return false
        elsif Bookmarks.idOutOfRange(bookmark,'bookmark_ID','bookmark') || Bookmarks.idOutOfRange(tag,'tag_ID','tag') then
            return false
        else 
            query = "INSERT INTO tag_bookmark_link(tag_ID,bookmark_ID)
                    VALUES(?,?);"
            @@db.execute query, tag, bookmark
            return true
        end 
    end
    
    # Add details of a view into the db
    def Bookmarks.addView(viewer, bookmark, dateViewed)
        if !Bookmarks.isInteger(viewer) or !Bookmarks.isInteger(bookmark) then
            return false
        elsif Bookmarks.isNull(bookmark) then
            return false
        elsif Bookmarks.idOutOfRange(viewer,'user_id','users') && viewer != nil then
            return false
        elsif Bookmarks.idOutOfRange(bookmark,'bookmark_id','bookmark') then
            return false
        else
            query = "INSERT INTO views(viewer_ID, bookmark_viewed_ID, view_date)
                    VALUES(?,?,?);"
            @@db.execute query, viewer, bookmark, dateViewed  
            return true
        end
    end 
end

