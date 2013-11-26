class Initialize

def self.initial
    client = Google::APIClient.new
    youtube = client.discovered_api('youtube','v3')
    youtube_analytics = client.discovered_api('youtubeAnalytics', 'v1')   

    require 'google/api_client/client_secrets'
    client.authorization = Google::APIClient::ClientSecrets.load('app/controllers/client_secrets.json').to_authorization

    # Initialize OAuth 2.0 client    
      client.authorization.client_id = '434092699375.apps.googleusercontent.com'
      client.authorization.client_secret = 'or1NmEWn2QOmObdok9No6jcV'
      client.authorization.scope = 'https://www.googleapis.com/auth/youtube.readonly', # may not be necessary
      'https://www.googleapis.com/auth/yt-analytics.readonly' # may not be necessary
      # client.authorization.access_token = session[:access_token]
      # client.authorization.refresh_token = session[:refresh_token]

      client
    end
end