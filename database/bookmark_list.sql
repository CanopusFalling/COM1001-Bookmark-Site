    
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