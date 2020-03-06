DROP TABLE IF EXISTS users;
CREATE TABLE users (
user_ID INTEGER NOT NULL PRIMARY KEY,
user_email VARCHAR(200) NOT NULL,
user_password_hash VARCHAR(255),
user_password_salt VARCHAR(255),
user_displayName VARCHAR(200),
user_department VARCHAR(200),
user_type VARCHAR(50),
user_suspended TINYINT NOT NULL
);

DROP TABLE IF EXISTS bookmark;
CREATE TABLE bookmark(
bookmark_ID INTEGER NOT NULL PRIMARY KEY,
bookmark_title VARCHAR(200),
bookmark_description VARCHAR(2000),
bookmark_link VARCHAR(500),
date_created DATETIME,
creator_ID INTEGER NOT NULL REFERENCES users(user_ID)
);

DROP TABLE IF EXISTS report;
CREATE TABLE report(
report_ID INTEGER NOT NULL PRIMARY KEY,
bookmark_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
reporter_ID INTEGER  REFERENCES users(user_ID),
report_details VARCHAR(2000),
report_date DATETIME,
report_resolved TINYINT
);

DROP TABLE IF EXISTS tag;
CREATE TABLE tag(
tag_ID INTEGER NOT NULL PRIMARY KEY,
tag_name VARCHAR(40),
tag_colour CHAR(10),
tag_date_created DATETIME
);

DROP TABLE IF EXISTS comment;
CREATE TABLE comment(
comment_ID INTEGER NOT NULL PRIMARY KEY,
bookmark_ID INTEGER NOT NULL REFERENCES bookmark(bookamark_ID),
commenter_ID INTEGER NOT NULL REFERENCES users(user_ID),
comment_details VARCHAR(2000),
date_created DATETIME,
date_deleted DATETIME
);

DROP TABLE IF EXISTS rating;
CREATE TABLE rating(
rating_ID INTEGER NOT NULL PRIMARY KEY,
bookmark_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
rater_ID INTEGER NOT NULL REFERENCES users(user_ID),
rating_value INTEGER,
rating_created DATETIME,
rating_deleted DATETIME
);

DROP TABLE IF EXISTS view;
CREATE TABLE view(
view_ID INTEGER NOT NULL PRIMARY KEY,
viewer_ID INTEGER REFERENCES users(user_ID),
bookmark_viewed_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
view_date DATETIME
);

DROP TABLE IF EXISTS edit;
CREATE TABLE edit(
    edit_ID INTEGER NOT NULL PRIMARY KEY,
    editor_ID INTEGER NOT NULL REFERENCES users(user_ID),
    bookmark_edited_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
    edit_date DATETIME
);

DROP TABLE IF EXISTS favourite;
CREATE TABLE favourite(
user_ID INTEGER NOT NULL REFERENCES users(user_ID),
bookmark_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
PRIMARY KEY (user_ID,bookmark_ID)
);

DROP TABLE IF EXISTS tag_bookmark_link;
CREATE TABLE tag_bookmark_link (
    tag_ID INTEGER NOT NULL REFERENCES tag(tag_ID),
    bookmark_ID INTEGER NOT NULL REFERENCES bookmark(bookmark_ID),
    PRIMARY KEY (tag_ID,bookmark_ID)
);