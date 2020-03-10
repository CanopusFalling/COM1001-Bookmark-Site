require 'sqlite3'

module Bookmarks
    
    DATABASE_DIRECTORY = ""
    UNVERIFIED_STRING = "Unverified"

    #Setup methods

    def Bookmarks.init
        @@db = SQLite3::Database.new DATABASE_DIRECTORY
        @@db.results_as_hash = true    
    end

    #Queries methods

    def Bookmarks.getHomepageData search
        result = nil
        if search
            query = "SELECT * FROM bookmark_list
                    WHERE title LIKE ?;"  
            result = @@db.execute query, "%#{search}%"
        end
        return result
    end


    def Bookmarks.getHomepageData
        Bookmarks.getHomepageData ""
    end

    def Bookmarks.currentUserEmails
        query = "SELECT DISTINCT user_email AS email
                FROM users;"
        result = @@db.execute query
        result.each do |row|
            row = row[:email]
        end
        return result
    end

    def Bookmarks.getPasswordHash? (email)
        result = nil
        if email && password
            query = "SELECT 
                    user_id AS id,
                    user_password AS password,
                    FROM users
                    WHERE login=?;"
            result = @@db.get_first_value query,email

        end
        return result
    end

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

            result[:details] = @db.get_first_value query , id.to_i

            query = "SELECT 
                    tag_name AS name,
                    tag_colour AS colour
                    FROM tag_bookmark_link JOIN tag USING(tag_ID)
                    WHERE bookmark_ID = ?;"
            result[:tags] = @@db.execute query, id.to_i
            
        end

        return result
    end

    def Bookmarks.getBookmarkDetails (bookmark_ID,user_ID)
            
        details = Bookmarks.getGuestBookmarkDetails bookmark_ID
        result = Hash.new
        result[:details] = details[:details]
        result[:tags] = details[:tags]
        result[:comments] = nil
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

    def Bookmarks.getTagNames
        query = "SELECT tag_name FROM tag";
        result = @@db.execute query
        result.each do |row|
            row=row[:tag_name]
        end

        return result
    end

    def Bookmarks.getUserDetails id
        result[:name] = nil
        result[:email] = nil
        result[:department] = nil
        if id.is_a? Integer
            query = "SELECT user_displayName AS name,
                    user_email AS email,
                    user_department AS department
                    FROM users
                    WHERE user_ID = ?;"
            result = @@db.get_first_value query, id.to_i
        end
        
        return result
    end

    def Bookmarks.getFavouriteList id
        result = nil
        if id.is_a? Integer
            query = "SELECT ID, title, rating, views 
                    FROM favourite JOIN bookmark_list ON ID=favourite_bookmark_ID
                    WHERE favourite_user_ID = ?;"
            result = @@db.execute query,id.to_i
        end

        return result
    end

    def Bookmarks.getUnverifiedList 
        query = "SELECT 
                user_ID AS ID,
                user_email AS email,
                user_displayName as displayName,
                user_department as department
                FROM users
                WHERE user_type = ?;"
        result = @@db.execute query, UNVERIFIED_STRING
        
        return result
    end
    
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

        return result
    end

    def Bookmarks.getViewHistory id
        result = nil
        if id.is_a? Integer
            query = "SELECT
                    bookmark_viewed_ID AS bookmark_ID,
                    view_date AS date
                    FROM views
                    WHERE viewer_ID = ?;"
            result = @@db.execute query, id.to_i
        end

        return result
    end

    def Bookmark.getUnresolvedReports
        query = "SELECT *
                FROM bookmark_list JOIN(
                    SELECT UNIQUE bookmark_ID
                    FROM reports
                    WHERE report_resolved = 0
                ) USING(bookmark_ID);"
        result = @@db.execute query
                    
        return result
    end

    def Bookmark.getReportedBookmarkDetails id
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
        end

        return result
    end
end
