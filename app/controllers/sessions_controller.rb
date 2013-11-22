class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth["provider"], :uid => auth["uid"]).first_or_initialize(
      :refresh_token => auth["credentials"]["refresh_token"],
      :access_token => auth["credentials"]["token"],
      :expires => auth["credentials"]["expires_at"],
      :name => auth["info"]["name"],
    )
    url = session[:return_to] || root_path
    session[:return_to] = nil
    url = root_path if url.eql?('/logout')

    if user.save
      session[:user_id] = user.id
      session[:access_token] = auth["credentials"]["token"]
      session[:refresh_token] = auth["credentials"]["refresh_token"]

      notice = "Signed in!"
      logger.debug "URL to redirect to: #{url}"
      redirect_to url, :notice => notice
    else
      raise "Failed to login"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def index
    # Which APIs and API versions to use
    @YOUTUBE_SCOPES = ['https://www.googleapis.com/auth/youtube.readonly',
      'https://www.googleapis.com/auth/yt-analytics.readonly']
    @YOUTUBE_API_SERVICE_NAME = 'youtube'
    @YOUTUBE_API_VERSION = 'v3'
    @YOUTUBE_ANALYTICS_API_SERVICE_NAME = 'youtubeAnalytics'
    @YOUTUBE_ANALYTICS_API_VERSION = 'v1'
    now = Time.new.to_i

    # Paramters to get traffic source information from Analytics API
    opts={:metrics=>"views", 
      :dimensions=>"insightTrafficSourceDetail", 
      :filters=>"video==ypGN6H3EKOA;insightTrafficSourceType==EXT_URL", 
      "start-date"=>"2011-01-01", "end-date"=>"2013-11-11", "start-index"=>1, 
      "max-results"=>5, :sort=>"-views", 
      :help=>false, 
      :ids=>"channel==UCHjzmXcM52GFvKQxsSEuZ-g"}
    @opts = opts

    # Parameters to get Average Minutes Watched and Average Percentage
    popts={:metrics=>"views,averageViewDuration,averageViewPercentage", 
      :filters=>"video==ypGN6H3EKOA", 
      "start-date"=>"2011-01-01", 
      "end-date"=>"2013-11-11", 
      "start-index"=>1, 
      "max-results"=>5, 
      :help=>false, :ids=>"channel==UCHjzmXcM52GFvKQxsSEuZ-g"}

    # Initialize the client, Youtube, and Youtube Analytics
    client = Google::APIClient.new(:application_name => "testdevelop",:application_version => "1.0")
    youtube = client.discovered_api(application_name:'youtube', application_version:'v3')
    youtube_analytics = client.discovered_api('youtubeAnalytics', 'v1')   
    # youtube = client.discovered_api(@YOUTUBE_API_SERVICE_NAME, @YOUTUBE_API_VERSION)
    # youtube_analytics = client.discovered_api(@YOUTUBE_ANALYTICS_API_SERVICE_NAME,
    #   @YOUTUBE_ANALYTICS_API_VERSION)

    require 'google/api_client/client_secrets'
    client.authorization = Google::APIClient::ClientSecrets.load('app/controllers/client_secrets.json').to_authorization

    # Initialize OAuth 2.0 client    
      client.authorization.client_id = '434092699375.apps.googleusercontent.com'
      client.authorization.client_secret = 'or1NmEWn2QOmObdok9No6jcV'
      client.authorization.redirect_uri = 'http://localhost:3000/auth/google_oauth2/callback'

      client.authorization.scope = 'https://www.googleapis.com/auth/youtube.readonly', # may not be necessary
      'https://www.googleapis.com/auth/yt-analytics.readonly' # may not be necessary

      client.authorization.update_token!(
        access_token: current_user[:access_token],
        refresh_token: current_user[:refresh_token] # may not be necessary
        )

###############################################################################
channels_response = client.execute!(
  :api_method => youtube.channels.list,
  :parameters => {
    :mine => true,
    :part => 'contentDetails',
    # :fields => 'snippet(title)'
  }
)
dataAPIparsed = channels_response.data.items.to_json
dataAPIparsed = JSON.parse(dataAPIparsed)
  # dataAPIparsed.each do |channel|

uploads_list_id = dataAPIparsed[0]['contentDetails']['uploads']

  playlistitems_response = client.execute!(
    :api_method => youtube.playlist_items.list,
    :parameters => {
      :playlistId => dataAPIparsed[0]['contentDetails']['relatedPlaylists']['uploads'],
      :part => 'snippet',
      :maxResults => 10
    }
  )

#   pts "Videos in list #{uploads_list_id}"
  @youtubeDataAPI =[]
  @dataIDs = []
  playlistitems_response.data.items.each do |playlist_item|
    @hash = Hash["title" => "",
              "id" => "",
              "url" => "",
              "thumbnails" => "" ]

    @hash['title'] = playlist_item['snippet']['title']
    @hash['id'] = playlist_item['snippet']['resourceId']['videoId']
    @dataIDs << playlist_item['snippet']['resourceId']['videoId']
    @hash['url'] = 'http://www.youtube.com/watch?v='+playlist_item['snippet']['resourceId']['videoId'].to_s
    @hash['thumbnails'] = JSON.parse(playlist_item.to_json)['snippet']['thumbnails']['medium']['url']
    @youtubeDataAPI << @hash
  end
    
    # Traffic from Facebook
    channels_response = client.execute!(
      :api_method => youtube.channels.list,
      :parameters => {
        :mine => true,
        :part => 'id'
      }
    )

    # @opts = channels_response.data
    @facebook = []
    @facebookHash={}
    @twitter = []
    @twitterHash ={}
    @averageViewDuration = []
    @averageViewPercentage =[]
    @totalViews=[]
    @total=[]
    @test =[]
    @viewCount_aveViewDuration_viewPercentage=[]

    i=0
    unless i == @dataIDs.count do     
    channels_response.data.items.each do |channel|
      opts[:ids] = "channel==#{channel.id}"
      opts[:filters]= "video=="+@dataIDs[i]+";insightTrafficSourceType==EXT_URL"
      @channelID= channel.id

      analytics_response = client.execute!(
        :api_method => youtube_analytics.reports.query,
        :parameters => opts
      )

      data = analytics_response.data.rows.select do |e| 
        e[0]=~/^(https?:\/\/)?(?:www\.)?(?:facebook)?(?:\.com)?$/
      end
      result= data.flatten
      @facebook << result.map {|x| Integer(x) rescue nil }.compact.sum

    # Traffic from Twitter
      data = analytics_response.data.rows.select do |e| 
        e[0]=~/^(https?:\/\/)?(?:www\.)?(?:youtu.be)?(?:\.com)?$/
      end
      result= data.flatten
      

      @twitter << result.map {|x| Integer(x) rescue nil }.compact.sum

      popts[:ids] = opts[:ids]
      popts[:filters]= "video=="+@dataIDs[i]

      analytics_response = client.execute!(
        :api_method => youtube_analytics.reports.query,
        :parameters => popts
      )
      @viewCount_aveViewDuration_viewPercentage << analytics_response.data.rows.flatten
     end  
     i+=1
  end

  i=0
  facebook = {}
  twitter = {}
  while i < @youtubeDataAPI.count do
    @youtubeDataAPI[i]["averageViewDuration"]= @viewCount_aveViewDuration_viewPercentage[i][1]
    @youtubeDataAPI[i]["totalViews"]=@viewCount_aveViewDuration_viewPercentage[i][0]
    @youtubeDataAPI[i]["averageViewPercentage"]= @viewCount_aveViewDuration_viewPercentage[i][2].to_f.round(2)
    @youtubeDataAPI[i]["facebookViews"]=@facebook[i]
    @youtubeDataAPI[i]["twitterViews"]=@twitter[i]
    i+=1
  end
   
end
end

def mailer
  @message=User.all
end

end

#Please show up on Github