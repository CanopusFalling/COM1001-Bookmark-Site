require 'sqlite3'

module Bookmarks
    
    DATABASE_DIRECTORY = ""

    def Bookmarks.init
        @@db = SQLite3::Database.new DATABASE_DIRECTORY
        @@db.results_as_hash = true    
    end

    def Bookmarks.getHomepageData search
        result = {}
        if search
            query = "SELECT * FROM bookmark_list
                    WHERE title LIKE ?;"  
            result = { :bookmark_list: => @@db.execute query, "%#{search}%"}
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

    def Bookmarks.correctLogin? (email, password)
        query = "SELECT 
                user_email AS login,
                user_password_hash AS hash,
                user_password_salt AS salt,
                user_suspended AS suspended
                FROM users
                WHERE login=?;"
        result = @@db.get_first_value query,email
        #TODO code login verification
        if result[:suspended] then return false
        

        return true
    end

    def Bookmarks.getGuestBookmarkDetails ID
        if id

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

            result[:details] = @db.get_first_value query , ID.to_i

            query = "SELECT 
                    tag_name AS name,
                    tag_colour AS colour
                    FROM tag_bookmark_link JOIN tag USING(tag_ID)
                    WHERE bookmark_ID = ?;"
            result[:tags] = @@db.execute query, ID.to_i



        
        else
            result[:details] = nil
            result[:tags] = nil
        end

        return result
    end

    def Bookmarks.getBookmarkDetails (bookmark_ID,user_ID)
            
        details = Bookmarks.getGuestBookmarkDetails bookmark_ID
        result[:details] = details[:details]
        result[:tags] = details[:tags]
        result[:comments] = nil
        result[:liked] = nil
        if user_ID 
            query = "SELECT 
            comment_details AS details,
            date_created AS created,
            date_deleted AS deleted,
            user_email AS email,
            user_displayName AS displayName
            FROM comment JOIN users ON commenter_ID = user_ID
            WHERE bookmark_ID = ?;"
            result[:comments] = @@db.execute query,user_ID
            
            if bookmark_ID
                query = "SELECT * FROM favourite
                WHERE user_ID = ? AND bookmark_ID = ?;"
                rows = @@db.execute query,user_ID,bookmark_ID
                if(rows.length() == 0) 
                    result[:liked] = false
                else     
                    result[:liked] = true
                end
            end
        end

        return result

    end



end