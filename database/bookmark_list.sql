-- Returns table with bookmark: id, title, avg rating and number of views
    CREATE VIEW bookmark_list AS
    SELECT 
    bookmark_ID AS ID,
    bookmark_title AS title,
    bookmark_link AS link,
    rating,
    views
    FROM (
        SELECT bookmark_ID, bookmark_title, bookmark_link, AVG(rating_value) AS rating
        FROM bookmark LEFT JOIN rating USING(bookmark_ID) 
        GROUP BY bookmark_ID
    ) LEFT JOIN (
        SELECT bookmark_viewed_ID AS bookmark_ID, COUNT(*) AS views
        FROM views
        GROUP BY bookmark_viewed_ID
    ) USING(bookmark_id);
