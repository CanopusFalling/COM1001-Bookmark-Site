# Project imports.
require 'sinatra'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'
require_relative 'ruby-scripts/user-authentication.rb'
require_relative 'ruby-scripts/support-functions.rb'
# For running the server from codio.
set :bind, '0.0.0.0'
enable :sessions

Bookmarks.init "../database/test.db"

before do
    if !session[:userID] 
        session[:userID] = -1
    end

end

# Redirect to the index view when a general 
# get connection is opened.
get '/' do
    @results = Bookmarks.getHomepageDataAll
    erb :index

end

get '/login' do
    if session[:userID] == -1 
        erb :loginpage
    else
        redirect '/'
    end

end


post '/authenticate-user' do

    @login = params[:user_email]
    @password = params[:user_password]
    @result = UserAuthentication.check @login , @password
    @error=""
    
    if @result == -1
        @error = "Invalid login or password"
    elsif @result == "Suspended"
        redirect '/msg?msg=suspended'
    elsif @result == "Unverified"
        redirect '/msg?msg=unverifiedMsg'
    else
        session[:userID] = @result
        redirect '/'
    end
    
    erb:loginpage

end

get '/registration' do
    if session[:userID] == -1 
        erb :registration
    else
        redirect '/'
    end

end

post '/registration' do

    @error_msg = getErrorMessage params
    @displayName = params[:displayName]
    @email = params[:email]
    @email_valid = params[:email_validation]
    
    if @error_msg == ""
        newUser @displayName , @email, params[:password]
        redirect '/msg?msg=newUser'
    else
        erb:registration
    end

end

# Search handling.
get '/search' do

    @searchQuery = params["search_query"]

    @fullResults = Bookmarks.getHomepageData @searchQuery
    @tagList = Bookmarks.getTagNames
    @checked = params[:showTag] ? [params[:showTag]] : (extractTagsFromParams params)
    
    if(@fullResults.length != 0) then
        @results = filterAgainstTags @fullResults, @checked
        erb :search
    else
        erb :noResults
    end

end

get '/report-bookmark' do
    erb :newReport

end

post '/report-bookmark' do

    @ID = params[:bookmarkID]
    @type = params[:category]
    @desc = params[:details]=="" ? nil : params[:details]
    @reporterID = session[:userID]

    newReport @ID, @reporterID, @type, @desc

    redirect '/msg?msg=reportThanks'

end

get '/bookmark-spesifics' do

    @ID = params[:bookmarkID]
    @details = Bookmarks.getBookmarkDetails(@ID.to_i)
    @title = @details[:details][:title]
    @desc = @details[:details][:description]
    @date = @details[:details][:date]
    @displayName = @details[:details][:displayName]
    @displayName = @details[:details][:email] if @displayName.nil?
    @avgRating = Bookmarks.getAvgRating(@ID)
    @tags = @details[:tags]
    @link = @details[:details][:link]
    
    @rateCount = Bookmarks.getRatingCount(@ID)
    @comments = Bookmarks.getComments(@ID)

    # if user logged in display add or change rating button depending on isRated
    if session[:userID] != -1 then
        @commentButton = erb :add_comment_button
        @ratingButton = params[:rate] ? nil : (erb :rating_button)
        @selectRating = params[:rate] ? (erb :rating_selection) : nil
    else 
        @commentButton = nil
        @ratingButton = nil
    end

    # Display comments if they exist
    if @comments.length() > 0 then
        @displayComments = erb :displayComments, :locals => {:comments => @comments}
    else
        @displayComments = nil
    end

    addView @ID, session[:userID]

    erb :bookmarkDetails
    
end

post '/bookmark-spesifics' do
   @userID =  session[:userID] 
   @bookmarkID = params[:bookmarkID]
   @value = params[:selection] 
    puts @value
    if Bookmarks.isInteger @value then
        if Bookmarks.isRated(@bookmarkID.to_i, @userID.to_i) == nil then
            if addRating @bookmarkID, @userID, @value then
                redirect '/msg?msg=ratingAddedMsg'
            end
        else
            if changeRating @bookmarkID, @userID, @value then
                redirect '/msg?msg=ratingAddedMsg'
            end
        end
    else
        redirect '/msg?msg=action_error_msg'
    end

end

get '/add-comment' do
    if session[:userID] != -1
        @bookmarkID = params[:bookmarkID]
        @userID = session[:userID]
        erb :addComment
    else
        redirect "/bookmark-spesifics?bookmarkID=#{params[:bookmarkID]}"
    end

end

post '/add-comment' do
    @comment = params[:comment]
    @bookmarkID = params[:bookmarkID]
    @userID = session[:userID]

    if addComment @bookmarkID, @userID, @comment then
        redirect '/msg?msg=commentAddedMsg'
    end

end

get '/delete-comment' do
        if session[:userID] != -1
        @commentID = params[:commentID]
        @userID = session[:userID]
        erb :deleteComment
    else
        redirect "/bookmark-spesifics?bookmarkID=#{params[:bookmarkID]}"
    end

end

post '/delete-comment' do
    @commentID = params[:commentID]
    @userID = session[:userID]

    if deleteComment @commentID then
        redirect '/msg?msg=commentDeleted'
    end

end


get '/newBookmark' do
    if session[:userID] != -1 
        if ((UserAuthentication.getAccessLevel session[:userID]) != 0)
            @tagList = Bookmarks.getTagNames
            erb :newBookmark
        else
            redirect '/msg?msg=waitForVerification'
        end
    else
        redirect '/'
    end

end

post '/newBookmark' do
    @title = params[:title]
    @link = params[:link]
    @desc = params[:desc]
    @tags = extractTagsFromParams params
    @userID = session[:userID]

    @newId = newBookmark @userID, @title, @link, @desc
    if @newId 
        assignTags @tags, @newId 
        redirect '/msg?msg=newBookmarkMsg' 
    end 

end

get '/edit-bookmark' do
    @ID = params[:bookmarkID].to_i
    if UserAuthentication.hasEditRights @ID, session[:userID]  
        @details = Bookmarks.getBookmarkDetails @ID
        @title = @details[:details][:title]
        @desc = @details[:details][:description]
        @link = @details[:details][:link]
        @tagList = Bookmarks.getTagNames
        @checked = Bookmarks.getBookmarkTagsNames @ID.to_i
        erb :editBookmark
    else
        redirect '/'
    end
    
end

post '/edit-bookmark' do
    @ID = params[:bookmarkID].to_i
    if UserAuthentication.hasEditRights @ID, session[:userID]
        @bookmarkID = params[:bookmarkID]
        @title = params[:title]
        @link = params[:link]
        @desc = params[:desc]
        @tags = extractTagsFromParams params
        @userID = session[:userID]
    
        updateBookmark @bookmarkID, @title, @link, @desc, @userID
        reAssignTags @tags, (Bookmarks.getBookmarkTagsNames @ID), @ID
        redirect '/msg?msg=updateBookmarkMsg' 
    else
        redirect '/'
    end
   
end


get '/delete-bookmark' do 
    @bookmarkID = params[:bookmarkID]
    if UserAuthentication.hasEditRights @bookmarkID, session[:userID] then
        erb :deleteBookmark
    else
        redirect '/msg?msg=deleteErrorMsg'
    end     

end        

post '/delete-bookmark' do
    @bookmarkID = params[:bookmarkID]

    deleteBookmark @bookmarkID
    redirect '/msg?msg=successfulDeleteMsg'
end

get '/bookmark-addView' do
    addView params[:bookmarkID], session[:userID]
    redirect back

end

get '/msg' do
    @message = params[:msg]==nil ? :defaultMsg : params[:msg].to_sym
    erb :message

end

# ======= Admin views =============
get '/adminMenu' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        erb :adminMenu
    else
        redirect '/'
    end

end

get '/approve-users' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @userList = Bookmarks.getUnverifiedList
        if @userList.length() > 0 then
            @unverifiedTable = erb :unverifiedTable, :locals => {:userList => @userList}
            erb :approveUsers
        else
            redirect '/msg?msg=noUnverifiedMsg'
        end
    else
        redirect '/'
    end

end 

get '/verify-user' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @userID = params[:userID]
        erb :confirmVerification
    else
        redirect '/'
    end
    
end

post '/verify-user' do
    @userID = params[:userID]
    puts params[:userID]
    if Bookmarks.verifyUser(@userID) then
        redirect '/msg?msg=verifySuccessMsg'
    end

end 

get '/reported-bookmarks' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @reportList = Bookmarks.getUnresolvedReports
        if @reportList.length() > 0 then
            @reportTable = erb :reportTable, :locals => {:reportList => @reportList}
            erb :reportedBookmarks
        else
            redirect '/msg?msg=noReportsMsg'
        end
    else
        redirect '/'
    end
end

get '/report-details' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @ID = params[:bookmarkID]
        @details = Bookmarks.getBookmarkDetails(@ID.to_i)
        @title = @details[:details][:title]
        @desc = @details[:details][:description]
        @date = @details[:details][:date]
        @displayName = @details[:details][:displayName]
        @displayName = @details[:details][:email] if @displayName.nil?
        @avgRating = Bookmarks.getAvgRating(@ID)
        @tags = @details[:tags]
        @link = @details[:details][:link]
        @rateCount = Bookmarks.getRatingCount(@ID)

        @reports = Bookmarks.getReportDetails(@ID)
        @displayReports = erb :displayReports, :locals => {:reports => @reports}



        erb :reportDetails
    else
        redirect '/'
    end
end

get '/resolve-report' do 
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        erb :resolveReport
    else
        redirect '/'
    end
end 

post '/resolve-report' do
    @ID = params[:bookmarkID]
    if Bookmarks.resolveReports(@ID) then
        redirect '/msg?msg=successfullyResolvedMsg'
    end
end 

get '/suspended-accounts' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @suspendedUserDetails = Bookmarks.getSuspendedUsers
        @suspendedTable = erb :suspendedTable, :locals => {:users => @suspendedUserDetails}
        erb :suspendedAccounts
    else
        redirect '/'
    end
end