# Project imports.
require 'sinatra'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'
require_relative 'ruby-scripts/user-authentication.rb'
require_relative 'ruby-scripts/support-functions.rb'
# For running the server from codio.
set :bind, '0.0.0.0'
enable :sessions
#set :show_exceptions => false


Bookmarks.init "../database/test.db"

before do
    
    if !session[:userID] 
        session[:userID] = -1
    end

    if session[:userID] && (session[:userID] != -1) 
        if (UserAuthentication.getAccessLevel session[:userID]) == 0
            session[:userID] = -1
            redirect '/msg?msg=accountUnavailableMsg'
        end
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

#attempted login
post '/authenticate-user' do

    @login = params[:user_email]
    @password = params[:user_password]

    #check credentials
    @result = UserAuthentication.check @login , @password
    
    if @result == -1
        @error = "Invalid login or password"   
    else
        #check if account is active and verified
        if (UserAuthentication.getAccessLevel @result) == 0
            @details = Bookmarks.getAccessDetails @result
            #if not check why
            if  @details[:user_suspended] == 1
                redirect '/msg?msg=suspendedMsg'
            elsif @details[:user_type] == Bookmarks::UNVERIFIED_STRING
                redirect '/msg?msg=unverifiedMsg'
            end
        elsif UserAuthentication.hasPasswordReset(@login) 
            redirect "/change-password?userID=#{@result}"
        else
            session[:userID] = @result
            redirect '/'
        end
    end
    
    erb:loginpage

end

get '/change-password' do
    if session[:userID] == -1 
        erb :changePassword
    else
        redirect '/'
    end
end

post '/change-password' do
    @error_msg = getPasswordErrorMsg params
    @ID = params[:userID]
    @password = params[:password]
    if @error_msg == ""
        if Bookmarks.resetPassword(@ID,@password) then
            session[:userID] = @ID
            redirect '/msg?msg=passwordChangedMsg'
        end
    else
        erb :changePassword
    end
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
        redirect '/msg?msg=newUserMsg'
    else
        erb:registration
    end

end

# Search handling.
get '/search' do

    @searchQuery = params["search_query"]

    @fullResults = Bookmarks.getHomepageData @searchQuery

    #variables for tagControl
    @tagList = Bookmarks.getTagNames
    #get tags for filter either from submitted form 
    #or redirected after clicking on a tag in bookmark details
    @checked = params[:showTag] ? [params[:showTag]] : (extractTagsFromParams params)
    
    if(@fullResults.length != 0) then
        @results = filterAgainstTags @fullResults, @checked
        erb :search
    else
        erb :noResults
    end

end

get '/report-bookmark' do
    
    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        erb :newReport
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end

post '/report-bookmark' do
    
    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        @ID = params[:bookmarkID]
        @type = params[:category]
        @desc = params[:details]=="" ? nil : params[:details]
        @reporterID = session[:userID]

        newReport @ID, @reporterID, @type, @desc

        redirect '/msg?msg=reportThanksMsg'
    else 
        redirect '/msg?msg=missingResourceMsg'
    end

end

get '/bookmark-spesifics' do

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
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

        if session[:userID] != -1 then
            @commentButton = erb :addCommentButton
            @ratingButton = params[:rate] ? nil : (erb :ratingButton)
            @selectRating = params[:rate] ? (erb :ratingSelection) : nil
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
    else
        redirect '/msg?msg=missingResourceMsg'
    end
    
end

#User submitted rating
post '/bookmark-spesifics' do
   
    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        @userID =  session[:userID] 
        @bookmarkID = params[:bookmarkID]
        @value = params[:selection] #submitted rating

        if Bookmarks.isInteger @value then

            #Either add or update the rating the user has already submitted
            if Bookmarks.getRating(@bookmarkID, @userID) == nil then
                success = addRating @bookmarkID, @userID, @value
            else
                success = changeRating @bookmarkID, @userID, @value 
            end

            if success then 
                redirect '/msg?msg=ratingAddedMsg'
            end
        end

        redirect '/msg?msg=actionErrorMsg'
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end

get '/add-comment' do

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        if session[:userID] != -1
            @bookmarkID = params[:bookmarkID]
            @userID = session[:userID]
            erb :addComment
        else
            redirect "/bookmark-spesifics?bookmarkID=#{params[:bookmarkID]}"
        end
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end

post '/add-comment' do

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        @comment = params[:comment]
        @bookmarkID = params[:bookmarkID]
        @userID = session[:userID]

        if addComment @bookmarkID, @userID, @comment then
            redirect '/msg?msg=commentAddedMsg'
        end
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end

get '/delete-comment' do

    if Bookmarks.resourceExists? params[:commentID], "comment"
        if session[:userID] != -1
        @commentID = params[:commentID]
        @userID = session[:userID]
        erb :deleteComment
        else
            redirect "/bookmark-spesifics?bookmarkID=#{params[:bookmarkID]}"
        end
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end

post '/delete-comment' do
    if Bookmarks.resourceExists? params[:commentID], "comment"
        @commentID = params[:commentID]
        @userID = session[:userID]

        if deleteComment @commentID then
            redirect '/msg?msg=commentDeletedMsg'
        end
    else
        redirect '/msg?msg=missingResourceMsg'
    end

end


get '/newBookmark' do
    if ((UserAuthentication.getAccessLevel session[:userID]) != 0)
        @tagList = Bookmarks.getTagNames
        erb :newBookmark
    else
        redirect '/msg?msg=waitForVerificationMsg'
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

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
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
    else
        redirect '/msg?msg=missingResourceMsg'
    end
    
end

post '/edit-bookmark' do

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
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
    else
        redirect '/msg?msg=missingResourceMsg'
    end
   
end


get '/delete-bookmark' do 

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        @bookmarkID = params[:bookmarkID]
        if UserAuthentication.hasEditRights @bookmarkID, session[:userID] then
            erb :deleteBookmark
        else
            redirect '/msg?msg=deleteErrorMsg'
        end   
    else
        redirect '/msg?msg=missingResourceMsg'
    end 

end        

post '/delete-bookmark' do
    
    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        @bookmarkID = params[:bookmarkID]

        deleteBookmark @bookmarkID
        redirect '/msg?msg=successfulDeleteMsg'
    else
        redirect '/msg?msg=missingResourceMsg'
    end 

end

get '/bookmark-addView' do

    if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
        addView params[:bookmarkID], session[:userID]
    end
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
        if Bookmarks.resourceExists? params[:userID], "users"
            @userID = params[:userID]
            erb :confirmVerification
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
    
end

post '/verify-user' do

    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @userID = params[:userID]
            puts params[:userID]
            if Bookmarks.verifyUser(@userID) then
                redirect '/msg?msg=verifySuccessMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end 

end 

get '/reported-bookmarks' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2 #Is current user an admin
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
        if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
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
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
    

end

get '/resolve-report' do 
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
            erb :resolveReport
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

post '/resolve-report' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:bookmarkID], "bookmark"
            @ID = params[:bookmarkID]
            if Bookmarks.resolveReports(@ID) then
                redirect '/msg?msg=successfullyResolvedMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

get '/suspended-accounts' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @suspendedUserDetails = Bookmarks.getSuspendedUsers
        if(@suspendedUserDetails.length > 0)
            @suspendedTable = erb :suspendedTable, :locals => {:users => @suspendedUserDetails}
            erb :suspendedAccounts
        else
            redirect '/msg?msg=noSuspendedUsersMsg'
        end
    else
        redirect '/'
    end
end

get '/remove-suspension' do 
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            erb :removeSuspension
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

post '/remove-suspension' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @ID = params[:userID]
            if Bookmarks.unsuspendUser(@ID) then
                redirect '/msg?msg=suspensionRemovedMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end

get '/delete-account' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            erb :deleteAccount
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

post '/delete-account' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @ID = params[:userID]
            if Bookmarks.deleteUser(@ID) then
                redirect '/msg?msg=accountDeletedMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end

get '/user-list' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        @verifiedList = Bookmarks.getVerifiedList
        @userTable = erb :userTable, :locals => {:userList => @verifiedList}
        erb :userList
    else
        redirect '/'
    end
end    

get '/promote-user' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            erb :promoteUser
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end

post '/promote-user' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @ID = params[:userID]
            if Bookmarks.promoteToAdmin(@ID) then
                redirect '/msg?msg=userPromotedMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

get '/reset-password' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            erb :passwordReset
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end    

post '/reset-password' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @ID = params[:userID]
            if Bookmarks.resetPassword(@ID) then
                redirect '/msg?msg=passwordResetMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end 

get '/suspend-user' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            erb :suspendUser
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end    

post '/suspend-user' do
    if (UserAuthentication.getAccessLevel session[:userID]) == 2
        if Bookmarks.resourceExists? params[:userID], "users"
            @ID = params[:userID]
            if Bookmarks.suspendUser(@ID) then
                redirect '/msg?msg=userSuspendedMsg'
            end
        else
            redirect '/msg?msg=missingResourceMsg'
        end
    else
        redirect '/'
    end
end

not_found do
    redirect '/'
end

#error do
#   redirect '/msg?msg=actionErrorMsg'
#end