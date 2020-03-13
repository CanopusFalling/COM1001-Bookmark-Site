require 'sqlite3'

module Bookmarks
    
    #===Constants declaration

    DATABASE_DIRECTORY = ""
    UNVERIFIED_STRING = "Unverified"

    #===Setup methods===

    #Run to open the database connection
    def Bookmarks.init
        puts DATABASE_DIRECTORY
        @@db = SQLite3::Database.open DATABASE_DIRECTORY
        @@db.results_as_hash = true
    end

    #===Queries methods===

    #Retursns list of bookmarks with titles containing param search
    #Params: search - what to look for in target titles
    #Returns: A array of hashes with following keys (or nil if input was incorrect): 
    #   :ID - id of a bookmark
    #   :title - title of a bookmark
    #   :rating - avg rating of a bookmark
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
    #   :rating - avg rating of a bookmark
    #   :views - total view count of a bookmark
    def Bookmarks.getHomepageData
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
    #   :password - user password_hash
    def Bookmarks.getPasswordHash email
        result = nil
        if email
            query = "SELECT 
                    user_id AS id,
                    user_password AS password,
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
    def Bookmarks.getBookmarkDetails (bookmark_ID,user_ID)
            
        details = Bookmarks.getGuestBookmarkDetails bookmark_ID
        result = Hash.new
        result[:details] = details[:details]
        result[:tags] = details[:tags]
        result[:comments] = []
        result[:liked] = nil
        if user_ID.is_a? Integer
            query = "SELECT 
            comment_details AS details,
            date_created AS created,
            date_deleted AS deleted,
            user_email AS email,
            user_displayName AS displayName
            FROM comment JOIN users ON commenter_ID = user_ID
            WHERE bookmark_ID = ?;"
            result[:comments] = @@db.execute query,user_ID.to_i
            result[:comments].map{|row| row.transform_keys!(&:to_sym)}
            
            if bookmark_ID.is_a? Integer
                query = "SELECT * FROM favourite
                WHERE user_ID = ? AND bookmark_ID = ?;"
                rows = @@db.execute query,user_ID.to_i,bookmark_ID.to_i
                if(rows.length() == 0) 
                    result[:liked] = false
                else     
                    result[:liked] = true
                end
            end
        end

        return result
    end

    #Returns: An array with all the tag names
    def Bookmarks.getTagNames
        query = "SELECT tag_name FROM tag";
        result = @@db.execute query
        result.each do |row|
            row = row["tag_name"]
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
    #   :rating - avg rating of a bookmark
    #   :views - total view count of a bookmark
    def Bookmarks.getFavouriteList id
        result = nil
        if id.is_a? Integer
            query = "SELECT ID, title, rating, views 
                    FROM favourite JOIN bookmark_list ON ID=favourite_bookmark_ID
                    WHERE favourite_user_ID = ?;"
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
    def Bookmarks.getUnverifiedList
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
    #   :rating - avg rating of a bookmark
    #   :views - total view count of a bookmark

    def Bookmarks.getUnresolvedReports
        query = "SELECT *
                FROM bookmark_list JOIN(
                    SELECT UNIQUE bookmark_ID
                    FROM reports
                    WHERE report_resolved = 0
                ) USING(bookmark_ID);"
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
end

