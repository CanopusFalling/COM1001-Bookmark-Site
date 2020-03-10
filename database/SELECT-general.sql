-- []-parameters


-- ===== Guest Homepage =====

    -- Get list of bookmarks matching search bar value (for “” just returns all bookmarks.)
    SELECT * FROM bookmark_list
    WHERE title LIKE '%[Current Searched title]%';


-- ===== Register Page =====

    -- Get existing emails to check if already in use.
    SELECT DISTINCT user_email AS email
    FROM users;


-- ===== Login Page =====

    SELECT 
    user_id AS id,
    user_password AS password,
    FROM users
    WHERE user_email=[input_email];
    

-- ===== Bookmark Details Page - GUEST =====

    -- Get info about bookmark and creator.
    SELECT 
    bookmark_ID AS ID,
    bookmark_title AS title,
    bookmark_description AS description,
    bookmark_link AS link,
    date_created AS date,
    user_email AS email,
    user_displayName AS displayName
    FROM bookmark JOIN users ON creator_ID = user_ID
    WHERE bookmark_ID = [current_bookmark_ID];

    -- Get tags for this bookmark.
    SELECT 
    tag_name AS name,
    tag_colour AS colour
    FROM tag_bookmark_link JOIN tag USING(tag_ID)
    WHERE bookmark_ID = [current_bookmark_ID];

    
-- ===== Employee Home Page =====

    -- Get list of bookmarks matching search bar value (for “” just returns all bookmarks.)
    SELECT * FROM bookmark_list
    WHERE title LIKE '%[Current Searched title]%';


-- ===== Employee Bookmark Details Page =====

    -- Get bookmark information.
    SELECT 
    bookmark_id AS ID,
    bookmark_title AS title,
    bookmark_description AS description,
    bookmark_link AS link,
    date_created AS date,
    user_email AS email,
    user_displayName AS displayName,
    one,
    two,
    three,
    four,
    five,
    counts
    FROM (bookmark JOIN users ON creator_ID = user_ID) 
    JOIN ratings_quantity USING(bookmark_ID)
    WHERE bookmark_ID = [current_bookmark_ID];

    -- Get tags for this bookmark.
    SELECT 
    tag_name AS name,
    tag_colour AS colour
    FROM tag_bookmark_link JOIN tag USING(tag_ID)
    WHERE bookmark_ID = [current_bookmark_ID];

    -- Get comments for this bookmark.
    SELECT 
    comment_details AS details,
    date_created AS created,
    date_deleted AS deleted,
    user_email AS email,
    user_displayName AS displayName
    FROM comment JOIN users ON commenter_ID = user_ID
    WHERE bookmark_ID = [current_bookmark_ID];

    -- Check if user liked the bookmark.
    SELECT * FROM favourite
    WHERE user_ID = [current_user_ID] AND bookmark_ID = [current_bookmark_ID];


-- ===== Add Bookmark Page =====

    -- To check if tags user is adding exist already.
    SELECT tag_name FROM tag; 


-- ===== User Profile Page =====

    -- Get informations to display on the page.
    SELECT user_displayName AS name,
    user_email AS email,
    user_department AS department
    FROM users
    WHERE user_ID = [current_user_ID];
    

-- ===== Favourites Page =====

    -- Get list of favourite bookmarks.
    SELECT ID, title, rating, views 
    FROM favourite JOIN bookmark_list ON ID=favourite_bookmark_ID
    WHERE favourite_user_ID = [current_user_ID];
    
    
-- ===== Unverified Users Page =====

    -- Get list of unverified users.
    SELECT 
    user_ID AS ID,
    user_email AS email,
    user_displayName as displayName,
    user_department as department
    FROM users
    WHERE user_type = [unverified_user_string];

-- ===== Verified Users Page =====

    -- Get list of verified users.
    SELECT 
    user_ID AS ID,
    user_email AS email,
    user_displayName AS displayName,
    user_department AS department,
    user_type AS status,
    user_suspended AS suspended
    FROM users
    WHERE NOT user_type = [unverified_user_string];

-- ===== User Datail's Edit Page =====

    -- Get user specific details.
    SELECT 
    user_displayName AS name,
    user_email AS email,
    user_department As department
    FROM users
    WHERE user_ID = [current_user_ID];

    -- Get user view history.
    SELECT
        bookmark_viewed_ID AS bookmark_ID,
        view_date AS date
        FROM views
        WHERE viewer_ID = [current_user_ID];

-- ===== Reported Bookmarks Page =====

    -- Get List of bookmarks with at least one unresolved report.
    SELECT *
    FROM bookmark_list JOIN(
        SELECT UNIQUE bookmark_ID
        FROM reports
        WHERE report_resolved = 0
    ) USING(bookmark_ID);

-- ===== Reported Bookmark Specific Page =====

    -- Get details of specific reported bookmark.
    SELECT 
        bookmark_title AS title,
        bookmark_link AS link,
        report_type AS report_type,
        report_details AS details
        FROM bookmark JOIN report USING(bookmark_ID)
        WHERE bookmark_ID = [current_bookmark_ID];

