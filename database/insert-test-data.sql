INSERT INTO users (user_email, user_password, user_displayname, user_department, user_type, user_suspended) VALUES 
('admin', '$2a$12$gUuuoWmimMINcAx1t6eHtefgtKk.pX6bnbt7aFOrp1tPpt1bfZQ3W', 'Testing Admin', 'Administration', 'admin', 0),
('user', '$2a$12$Ip235iGWoPkFMSDRH2huA.f9NbuCBkNUXs8LvVoJRXpnDCSXqYMrS', 'Testing User', 'Customer Service', 'User', 0),
('role1', '$2a$12$NHa1bd7DG5/DWG7RZl6je.BgsaFRFxrGXmmdboCi25Y4alOtui75q', 'Testing Unapproved User', 'Customer Service', 'Unverified', 0),
('role2', '$2a$12$xY8v3veFo0PDDSui8PoV.e7xe5FiCTSc/ywn1iryrEGIjfuOoNNr2', 'TestingRole2', 'Customer Service', 'Unverified', 0),
('role3', '$2a$12$Z8JNeBf0l1pitHpIFwC1QeF3GXqGXgqeySwK4wdCwLpbQt71itvA6', 'TestingRole2', 'Customer Service', 'User', 0),
('role4', '$2a$12$ktzwnu22WfwsEbK/ySwdK.9eaa.X/kghCqYjLc.1/gDJqFjPab/hu', 'TestingRole2', 'Customer Service', 'User', 0);

INSERT INTO bookmark (bookmark_title, bookmark_description, bookmark_link, date_created, creator_id) VALUES
('Google', 'Link to the popular search engine google.', 'google.com', '2020-04-06', 0),
('Bing', 'Link to the less popular search engine bing. Like they say, bing it.', 'bing.com', '2020-04-06', 0),
('Youtube Video', 'The best youtube video know to mankind.', 'www.youtube.com/watch?v=dQw4w9WgXcQ', '2020-04-01', 0),
('SQL Dates', 'The W3 schools page I happended to have open while I was filling this in...', 'www.w3schools.com/Sql/sql_dates.asp', '2020-04-06', 0),
('Google Maps', 'Link to the popular method to navigate, google maps.', 'www.google.co.uk/maps', '2020-04-06', 0),
('Repository', 'Found this random repository on gitlab, pretty rubbish if you ask me.', 'git.shefcompsci.org.uk/com1001-2019-20/team04/project', '2020-04-06', 0),
('Tree 1', 'I like how this tree looks', 'upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg', '2019-08-04', 1),
('Tree 2', 'I like how this tree also looks', 'ichef.bbci.co.uk/wwfeatures/live/976_549/images/live/p0/7n/19/p07n19vr.jpg', '2019-08-05', 1),
('Tree 3', 'I like how this tree also also looks', 'static.scientificamerican.com/sciam/cache/file/06A21B2C-B9E4-4AC1-83AE0BE0FA01D980_source.jpg?w=590&h=800&DE76A122-A846-4E4B-BD82F52FBF34629F', '2019-08-06', 1),
('Tree 4', 'I like how this tree also also also looks', 'media.treehugger.com/assets/images/2016/07/green-forest-trees.jpg.860x0_q70_crop-scale.jpg', '2019-08-07', 1),
('Tree 5', 'I like how this tree also also also also looks', 'www.salisburyjournal.co.uk/resources/images/9741509/', '2019-08-08', 1),
('Tree 6', 'I like how this tree also also also also also looks', 'images.immediate.co.uk/production/volatile/sites/4/2018/08/iStock_78579229_XLARGE-2aa4b63.jpg?quality=90&resize=940%2C400', '2019-08-09', 1),
('Google News', 'Latest news related to you.', 'news.google.com/topstories', '2020-04-06', 4),
('Bing News', 'News that is completely irrelevant to anything, and it has no SSL cert like some sort of scrub website.', 'www.bing.com/news', '2020-04-06', 4),
('Jeeves', 'They got rid of Jeeves but I will forever remember him, what a legend.', 'uk.ask.com/', '2020-04-06', 4),
('Circuit Laundry - Ranmoor', 'Links to the status of all the washers and dryers in ranmoor, no real reason for this other than I am starting to run out of ideas for bookmarks.', 'www.circuit.co.uk/circuit-view/laundry-site/?site=6482', '2020-04-06', 4),
('Google', 'Link to the popular search engine google. (Deliberate test repeat bookmark.)', 'google.com', '2020-04-06', 5),
('RSI - NHS', 'This is the website I now need after making all this test data.', 'www.nhs.uk/conditions/repetitive-strain-injury-rsi/treatment/', '2020-04-06', 5);

INSERT INTO report(bookmark_id, reporter_id, report_type, report_details, report_date, report_resolved) VALUES
(0, 1, "broken link", "The link is broken, it keeps on saying can't connect to internet.", '2020-02-06', '2020-02-08'),
(0, 1, "broken link", "I've reported this before but it's still not gone", '2020-02-09', '2020-02-10'),
(0, 1, "broken link", "Does anyone check these reports, I will be emailing HR about this if this bookmark is not taken down.", '2020-02-20', '2020-02-22'),
(0, 1, "broken link", "Nevermind, I hadn't plugged in the ethernet cable.", '2020-02-22', '2020-02-22'),
(2, 1, "not funny", "This is not a funny, please remove with immediet effect.", CURRENT_TIMESTAMP, null),
(6, 2, "broken link", "its broke", CURRENT_TIMESTAMP, null),
(5, 2, "broken link", "lol, the link broke", CURRENT_TIMESTAMP, null),
(8, 3, "broken link", "I'm running out of ideas for comments.", CURRENT_TIMESTAMP, null),
(11, 3, "broken link", "Right well the rest will be blank.", CURRENT_TIMESTAMP, null),
(13, 4, "broken link", "", CURRENT_TIMESTAMP, null),
(12, 3, "broken link", "", CURRENT_TIMESTAMP, null),
(7, 5, "broken link", "", CURRENT_TIMESTAMP, null);

INSERT INTO tag(tag_name, tag_colour, tag_date_created) VALUES
("Search engines", "rgba(0, 0, 160, 0.3)", CURRENT_TIMESTAMP),
("Bad search engines", "rgba(255, 0, 0, 0.6)", CURRENT_TIMESTAMP),
("Tree", "rgba(0, 255, 0, 0.5)", CURRENT_TIMESTAMP),
("Medical", "rgba(0, 0, 200, 0.9)", CURRENT_TIMESTAMP);

INSERT INTO comment(bookmark_ID, commenter_ID, comment_details, date_created, date_deleted) VALUES
(0, 0, "Google", '2020-02-03', '2020-02-04'),
(0, 0, "It's google, use as you see fit.", CURRENT_TIMESTAMP, null),
(0, 1, "Can't load the page", CURRENT_TIMESTAMP, null),
(1, 1, "I prefer this search engine", CURRENT_TIMESTAMP, null);