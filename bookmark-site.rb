# Project imports.
require 'sinatra'
require 'bcrypt'
require_relative 'ruby-scripts/database-model.rb'
require_relative 'user-authentication.rb'
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
    else
        session[:userID] = @result
        redirect '/'
    end
    
    erb:loginpage

end

get '/registration' do
    erb :registration
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

    @results = Bookmarks.getHomepageData @searchQuery
    
    if(@results.length != 0) then
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
    @details = Bookmarks.getGuestBookmarkDetails @ID.to_i
    @title = @details[:details][:title]
    @desc = @details[:details][:description]
    @date = @details[:details][:date]
    @displayName = @details[:details][:displayName]
    @displayName = @details[:details][:email] if @displayName == nil
    @avgRating = Bookmarks.getAvgRating(@ID)
    @link = @details[:details][:link]
    @addRating = nil
    @changeRating = nil
    @rateCount = Bookmarks.getRatingCount(@ID)
    @comments = Bookmarks.getComments(@ID)

    # if user logged in display add or change rating button depending on isRated
    if session[:userID] != -1 then
        @commentButton = erb :add_comment_button
        if Bookmarks.isRated(@ID.to_i,session[:userID].to_i) == nil then
            @ratingButton = erb :add_rating_button
        else 
            @ratingButton = erb :change_rating_button
        end
    else 
        @ratingButton = nil
        @commentButton = nil
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

get '/add-rating' do
    @ID = params[:bookmarkID]
    @details = Bookmarks.getGuestBookmarkDetails @ID.to_i
    @title = @details[:details][:title]
    @desc = @details[:details][:description]
    @date = @details[:details][:date]
    @displayName = @details[:details][:displayName]
    @displayName = @details[:details][:email] if @displayName == nil
    @avgRating = Bookmarks.getAvgRating(@ID)
    @link = @details[:details][:link]
    @addRating = erb :addRating
    @changeRating = nil
    @rateCount = Bookmarks.getRatingCount(@ID)
    @comments = Bookmarks.getComments(@ID)
    # Display comments if they exist
    if @comments.length() > 0 then
        @displayComments = erb :displayComments, :locals => {:comments => @comments}
    else
        @displayComments = nil
    end

    erb :bookmarkDetails
end


post '/add-rating' do
   @userID =  session[:userID] 
   @bookmarkID = params[:bookmarkID]
   @value = params[:selection] 

   if addRating @bookmarkID, @userID, @value then
        redirect '/msgGoHome?msg=ratingAddedMsg'
   end
end


get '/change-rating' do
    @ID = params[:bookmarkID]
    @details = Bookmarks.getGuestBookmarkDetails @ID.to_i
    @title = @details[:details][:title]
    @desc = @details[:details][:description]
    @date = @details[:details][:date]
    @displayName = @details[:details][:displayName]
    @displayName = @details[:details][:email] if @displayName == nil
    @avgRating = Bookmarks.getAvgRating(@ID)
    @link = @details[:details][:link]
    @addRating = nil
    @changeRating = erb :changeRating
    @rateCount = Bookmarks.getRatingCount(@ID)
    @comments = Bookmarks.getComments(@ID)
    # Display comments if they exist
    if @comments.length() > 0 then
        @displayComments = erb :displayComments, :locals => {:comments => @comments}
    else
        @displayComments = nil
    end

    erb :bookmarkDetails
end

post '/change-rating' do
   @userID =  session[:userID] 
   @bookmarkID = params[:bookmarkID]
   @value = params[:selection] 

   if changeRating @bookmarkID, @userID, @value then
        redirect '/msgGoHome?msg=ratingChangedMsg'
   end
end

get '/add-comment' do
    @bookmarkID = params[:bookmarkID]
    @userID = session[:userID]
    erb :addComment
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
    @commentID = params[:commentID]
    @userID = session[:userID]
    erb :deleteComment
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
        if Bookmarks.isVerified session[:userID]
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
    if session[:userID] != -1 
        @ID = params[:bookmarkID].to_i
        if Bookmarks.isVerified session[:userID] 
            if session[:userID] ==(Bookmarks.getBookmarkCreator @ID)
                @details = Bookmarks.getGuestBookmarkDetails @ID
                @title = @details[:details][:title]
                @desc = @details[:details][:description]
                @desc = "" if @desc.nil?
                @desc.sub! '<', '\<'
                @desc.sub! '>', '\>'
                @link = @details[:details][:link]
                @tagList = Bookmarks.getTagNames
                @checked = Bookmarks.getBookmarkTagsNames @ID.to_i
                erb :editBookmark
            else
                redirect '/'
            end
        else
            redirect '/'
        end
    else
        redirect '/'
    end
end

get '/delete-bookmark' do 
    @bookmarkID = params[:bookmarkID]
    @userID = session[:userID]
    @creator = Bookmarks.getBookmarkCreator(@bookmarkID)
   if @userID == @creator then
        erb :deleteBookmark
   else
        redirect '/msg?msg=deleteError'
   end       
end        

post '/delete-bookmark' do
    @bookmarkID = params[:bookmarkID]

    deleteBookmark @bookmarkID
    redirect '/msgGoHome?msg=successfulDelete'
end

get '/bookmark-addView' do
    addView params[:bookmarkID], session[:userID]
    redirect back
end

get '/msg' do
    @message = params[:msg]==nil ? :defaultMsg : params[:msg].to_sym
    erb :message
end

get '/msgGoHome' do
    @message = params[:msg]==nil ? :defaultMsg : params[:msg].to_sym
    erb :messageGoHome
end

get '/testing' do
    @tagList = Bookmarks.getTagNames
    @checked = ['tag0']
    @returnedTags = extractTagsFromParams params
    erb :test
end 

get '/adminMenu' do
    erb :adminMenu
end