
    -- quantity of each value of rating
    CREATE VIEW ratings_quantity AS 
    SELECT
        bookmark_ID,
        COUNT(one) AS one,
        COUNT(two) AS two,
        COUNT(three) AS three,
        COUNT(four) AS four,
        COUNT(five) AS five,
        COUNT(any) AS counts
        FROM bookmark LEFT JOIN(
            SELECT
            bookmark_ID,
            CASE WHEN rating_value = 1 THEN 1 END one,
            CASE WHEN rating_value = 2 THEN 1 END two,
            CASE WHEN rating_value = 3 THEN 1 END three,
            CASE WHEN rating_value = 4 THEN 1 END four,
            CASE WHEN rating_value = 5 THEN 1 END five,
            CASE WHEN TRUE THEN 1 END any
            FROM rating
        )USING(bookmark_ID)
    GROUP BY bookmark_ID;