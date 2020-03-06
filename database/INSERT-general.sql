/* [] means the data is optional */
/* {} means the data is a placeholder */

/* For REGISTER page */
INSERT INTO users (user_email, /*[user_display_name,] [user_department,]*/ password_hash, password_salt)
VALUES ('{user_email}', /*['{user_display_name}',] ['{user_department}',]*/ '{password_hash}', '{password_salt}');

/* For LOG_IN page */
INSERT INTO users (user_email, password_hash, password_salt)
VALUES ('{user_email}', '{password_hash}', '{password_salt}');

/* for REPORT page */
INSERT INTO reports (report_type, /*[report_details,] [reporter_id,]*/ report_date)
VALUES ('{report_type}', /*[{report_details},] [{reporter_id},]*/ '{report_date}');
