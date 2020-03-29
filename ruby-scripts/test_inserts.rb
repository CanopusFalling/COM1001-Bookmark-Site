require 'minitest/autorun'
require_relative 'database-model.rb'

class TestInserts < Minitest::Test
   Bookmarks.init('../database/test.db')

   def test_add_user
        # Test with valid details
        valid1 = Bookmarks.addRegisterDetails("aaa@gmail.com","UserA","Dep1","pword007")
        valid2 = Bookmarks.addRegisterDetails("abc@bookmark.com","UserB","Dep2","password")
        valid3 = Bookmarks.addRegisterDetails("abcdef@email.com","UserC","Dep3","p@ssword")
        # Test for ouptut with repeated email
        sameEmail = Bookmarks.addRegisterDetails("aaa@gmail.com","aSmith123","Computer Science","pword007")
        # Test for output with null email
        nullEmail = Bookmarks.addRegisterDetails(nil,"pJones2","Computer Science","pword007") 
        
        assert valid1
        assert valid2
        assert valid3
        # Expect output to be false
        refute sameEmail
        refute nullEmail
    end 

    def test_add_admin
        # Test with valid details
        valid1 = Bookmarks.addAdminUser("abc@abc.com","User01","Dep1","password")
        valid2 = Bookmarks.addAdminUser("xxx@hotmail.com","UserX","Dep4","PassWord")
        valid3 = Bookmarks.addAdminUser("admin@email.com","Admin1","Dep2","passW")
        # Test for ouptut with repeated email
        sameEmail = Bookmarks.addAdminUser("abc@abc.com","User01","Dep1","password")
        # Test for output with null email
        nullEmail = Bookmarks.addAdminUser(nil,"User02","Dep2","pword") 
        
        assert valid1
        assert valid2
        assert valid3

        # Expect output to be false
        refute sameEmail
        refute nullEmail
    end 

    def test_add_bookmark
        # Test with valid details
        valid1 = Bookmarks.addBookmark("Bookmark1","Description","www.bookmark.com",'1.01.2001',1)
        valid2 = Bookmarks.addBookmark("Bookmark2","Description","www.test.com",'1.01.2001',2)
        valid3 = Bookmarks.addBookmark("Bookmark3","Description","www.website.com",'1.01.2001',3)
        
        # Test with link already in db
        sameLink = Bookmarks.addBookmark("Bookmark4","Description","www.bookmark.com",'5.01.2001',1)
        # null bookmark_title
        nullTitle = Bookmarks.addBookmark(nil,"Description","www.abc.com",'5.05.2005',1)
        # creator_id not a valid user_id
        creatorOutOfRange = Bookmarks.addBookmark("Bookmark5","Description","www.aaaaa.com",'5.01.2001',150)

        assert valid1
        assert valid2
        assert valid3
        
        refute sameLink
        refute nullTitle
        refute creatorOutOfRange
    end 

    def test_add_edit 
        # Test with valid details
        valid1 = Bookmarks.addBookmarkEdit(1,1,"1.1.2001")
        valid2 = Bookmarks.addBookmarkEdit(2,2,"1.3.2010")
        valid3 = Bookmarks.addBookmarkEdit(3,3,"19.4.2012")

        # non-integer editor_ID
        editorNotInt = Bookmarks.addBookmarkEdit("x",1,"1.1.2001")
        # non-integer bookmark_ID
        bookmarkNotInt = Bookmarks.addBookmarkEdit(1,"b","1.1.2001")
        # null editor_ID
        editorNull = Bookmarks.addBookmarkEdit(nil,1,"1.1.2001")
        # null bookmark_ID
        bookmarkNull = Bookmarks.addBookmarkEdit(1,nil,"1.1.2001")
        # editor_ID not in db
        editorOutOfRange = Bookmarks.addBookmarkEdit(10,1,"1.1.2001")
        # bookmark_ID not in db
        bookmarkOutOfRange = Bookmarks.addBookmarkEdit(1,10,"1.1.2001")
        # ID values are negative
        negativeID = Bookmarks.addBookmarkEdit(-1,-1,"1.1.2001")

        assert valid1
        assert valid2
        assert valid3

        refute editorNotInt
        refute bookmarkNotInt
        refute editorNull
        refute bookmarkNull
        refute editorOutOfRange
        refute bookmarkOutOfRange
        refute negativeID
    end
 
    def test_add_comment 
        # Test with valid details
        valid1 = Bookmarks.addComment(1,1,"edit1","12.12.2012")
        valid2 = Bookmarks.addComment(2,2,"edit2","21.9.2008")
        valid3 = Bookmarks.addComment(3,3,"edit3","22.2.2002")

        # non-integer bookmark_id
        bookmarkNotInt = Bookmarks.addComment("x",1,"edit01","12.12.2012")
        # non-integer commenter_id
        commenterNotInt = Bookmarks.addComment(2,"aaa","edit02","12.12.2012")
        # null bookmark_id
        bookmarkNull = Bookmarks.addComment(nil,1,"edit03","12.12.2012")
        # null commenter_id
        commenterNull = Bookmarks.addComment(3,nil,"edit04","12.12.2012")
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addComment(30,3,"edit05","12.12.2012")
        # commenter_id not in db
        commentOutOfRange = Bookmarks.addComment(3,20,"edit06","12.12.2012")
        # ID values are negative
        negativeID = Bookmarks.addComment(-1,-1,"edit07","12.12.2012")

        assert valid1
        assert valid2
        assert valid3

        refute bookmarkNotInt
        refute commenterNotInt
        refute bookmarkNull
        refute commenterNull
        refute bookmarkOutOfRange
        refute commentOutOfRange
        refute negativeID
    end


    def test_add_favourite
        # Test with valid details
        valid1 = Bookmarks.addFavourite(1,1)
        valid2 = Bookmarks.addFavourite(2,2)
        valid3 = Bookmarks.addFavourite(3,3)

        # non-integer user_ID
        userNotInt = Bookmarks.addFavourite('x',1)
        # non-integer bookmark_ID
        bookmarkNotInt = Bookmarks.addFavourite(1,'x')
        # null user_ID
        userNull = Bookmarks.addFavourite(nil,1)
        # null bookmark_id
        bookmarkNull = Bookmarks.addFavourite(2,nil)
        # user_id out of range
        userOutOfRange = Bookmarks.addFavourite(25,1)
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addFavourite(3,100)
        # ID values are negative
        negativeID = Bookmarks.addFavourite(-1,-10)

        assert valid1
        assert valid2
        assert valid3

        refute userNotInt
        refute bookmarkNotInt
        refute userNull
        refute bookmarkNull
        refute userOutOfRange
        refute bookmarkOutOfRange
        refute negativeID
    end

    def test_add_rating
        valid1 = Bookmarks.addRating(1,1,5,"12.12.2012")
        valid2 = Bookmarks.addRating(2,2,3,"12.12.2012")
        valid3 = Bookmarks.addRating(3,3,1,"12.12.2012")

        # non-integer bookmark_id
        bookmarkNotInt = Bookmarks.addRating("five",4,1,"12.12.2012")
        # non-integer rater_id
        raterNotInt = Bookmarks.addRating(3,"x",3,"12.12.2012")
        # non-integer rating value
        valueNotInt = Bookmarks.addRating(3,3,2.5,"12.12.2012")
        # null bookmark_id
        bookmarkNull = Bookmarks.addRating(nil,3,1,"12.12.2012")
        # null rater_id
        raterNull = Bookmarks.addRating(3,nil,1,"12.12.2012")
        # null value
        valueNull = Bookmarks.addRating(1,4,nil,"12.12.2012")
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addRating(300,3,1,"12.12.2012")
        # rater_id not in db
        raterOutOfRange = Bookmarks.addRating(3,150,1,"12.12.2012")
        # rating value out of range (1-5)
        valueOutOfRange = Bookmarks.addRating(4,5,10,"12.12.2012")
        # values are negative
        negativeValues = Bookmarks.addRating(-1,-1,-2,"12.12.2012")
        
        assert valid1
        assert valid2
        assert valid3

        refute bookmarkNotInt
        refute raterNotInt
        refute valueNotInt
        refute bookmarkNull
        refute raterNull
        refute valueNull
        refute bookmarkOutOfRange
        refute raterOutOfRange
        refute valueOutOfRange
        refute negativeValues  
    end

    def test_add_report
        # Test with valid details
        valid1 = Bookmarks.addReport(1,"Link doesn't work","error......",1,"2.02.2020")
        valid2 = Bookmarks.addReport(2,"Repetition","error......",2,"2.02.2020")
        valid3 = Bookmarks.addReport(3,"Wrong tags","error .......",3,"2.02.2020")

        # non-integer bookmark_id
        bookmarkNotInt = Bookmarks.addReport(1.5,"Link doesn't work","error........",1,"2.02.2020")
        # non-integer reporter_id
        reporterNotInt = Bookmarks.addReport(3,"Wrong tags","error .......","x","2.02.2020")
        # null bookmark_id
        bookmarkNull = Bookmarks.addReport(nil,"Wrong tags","error .......",4,"2.02.2020")
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addReport(100,"Link doesn't work","error......",1,"2.02.2020")
        # reporter_id not in db
        reporterOutOfRange = Bookmarks.addReport(1,"Link doesn't work","error......",55,"2.02.2020")
        # ID values are negative
        negativeID = Bookmarks.addReport(-1,"Link doesn't work","error......",-1,"2.02.2020")

        assert valid1
        assert valid2
        assert valid3

        refute bookmarkNotInt
        refute reporterNotInt
        refute bookmarkNull
        refute bookmarkOutOfRange
        refute reporterOutOfRange
        refute negativeID
    end

    def test_add_tag
        # Test with valid details
        valid1 = Bookmarks.addTag("Tag1","red","10.10.2018")
        valid2 = Bookmarks.addTag("Tag2","red","10.10.2018")
        valid3 = Bookmarks.addTag("Tag3","green","10.10.2018")

        # null tag name
        nullName = Bookmarks.addTag(nil,"red","10.10.2018")
        # null colour
        nullColour = Bookmarks.addTag("Tag4",nil,"10.10.2018")
        # null date
        nullDate = Bookmarks.addTag("Tag5","blue",nil)
        
        assert valid1
        assert valid2
        assert valid3
        assert nullColour
        assert nullDate

        refute nullName
    end

    def test_tag_bookmark_link
        # Test with valid details
        valid1 = Bookmarks.addTagBookmarkLink(1,1)
        valid2 = Bookmarks.addTagBookmarkLink(2,2)
        valid3 = Bookmarks.addTagBookmarkLink(3,3)

        # non-integer bookmark_id
        bookmarkNotInt = Bookmarks.addTagBookmarkLink("b",3)
        # non-integer tag_id
        tagNotInt = Bookmarks.addTagBookmarkLink(2,2.5)
        # null bookmark_id
        bookmarkNull = Bookmarks.addTagBookmarkLink(nil,5)
        # null tag_id
        tagNull = Bookmarks.addTagBookmarkLink(6,nil)
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addTagBookmarkLink(300,3)
        # tag_id not in db
        tagOutOfRange = Bookmarks.addTagBookmarkLink(5,300)
        # ID values are negative
        negativeID = Bookmarks.addTagBookmarkLink(-1,-2)
    
        assert valid1
        assert valid2
        assert valid3
        
        refute bookmarkNotInt
        refute tagNotInt
        refute bookmarkNull
        refute tagNull
        refute bookmarkOutOfRange
        refute tagOutOfRange
        refute negativeID
    end

    def test_add_view
        # Test with valid details
        valid1 = Bookmarks.addView(1,1,"29.03.2020")
        valid2 = Bookmarks.addView(2,2,"29.03.2020")
        valid3 = Bookmarks.addView(3,3,"20.04.2020")

        # non-integer viewer_id
        viewerNotInt = Bookmarks.addView("x",3,"20.04.2020")
        # non-integer bookmark_id
        bookmarkNotInt = Bookmarks.addView(2,2.99,"29.03.2020")
        # null bookmark_id
        bookmarkNull = Bookmarks.addView(nil,5,"20.04.2020")
        # bookmark_id not in db
        bookmarkOutOfRange = Bookmarks.addView(200,3,"29.03.2020")
        # viewer_id not in db
        viewerOutOfRange = Bookmarks.addView(2,200,"29.03.2020")
        # ID values are negative
        negativeID = Bookmarks.addView(-2,-5,"29.03.2020")

        assert valid1
        assert valid2
        assert valid3

        refute viewerNotInt
        refute bookmarkNotInt
        refute bookmarkNull
        refute bookmarkOutOfRange
        refute viewerOutOfRange
        refute negativeID
    end
end