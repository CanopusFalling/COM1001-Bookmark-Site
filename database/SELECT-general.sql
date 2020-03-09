-- []-parameters

-- ===== General views =====

    -- quantity of each value of rating
    CREATE VIEW ratings_quantity AS 
    SELECT
        bookmark_ID,
        COUNT(one) AS one,
        COUNT(two) AS two,
        COUNT(three) AS three,
        COUNT(four) AS four,
        COUNT(five) AS five,
        COUNT(*) AS counts
        FROM(
            SELECT
            bookmark_ID,
            CASE WHEN rating_value = 1 THEN 1 END one,
            CASE WHEN rating_value = 2 THEN 1 END two,
            CASE WHEN rating_value = 3 THEN 1 END three,
            CASE WHEN rating_value = 4 THEN 1 END four,
            CASE WHEN rating_value = 5 THEN 1 END five
            FROM rating
        )
    GROUP BY bookmark_ID;

    -- Returns table with bookmark: id, title, avg rating and number of views
    CREATE VIEW bookmark_list AS
    SELECT 
    bookmark_ID AS ID,
    bookmark_title AS title,
    rating
    views
    FROM (
        bookmark JOIN (
            SELECT bookmark_ID, AVG(rating_value) AS rating
            FROM rating 
            GROUP BY bookmark_ID
        ) USING(bookmark_ID)
    ) JOIN (
        SELECT bookmark_viewed_ID AS bookmark_ID, COUNT(*) AS views
        FROM view
        GROUP BY bookmark_ID
    ) USING(bookmark_id);


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
    user_email AS login,
    user_password_hash AS hash,
    user_password_salt AS salt,
    user_suspended AS suspended
    FROM users
    WHERE login=[login_input];
    

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

