class Video < ActiveRecord::Base
# require 'google/api_client'
	has_many :social_platform_totals
	def self.fuck
		@YOUTUBE_SCOPES = ['https://www.googleapis.com/auth/youtube.readonly',
		  'https://www.googleapis.com/auth/yt-analytics.readonly']
		@YOUTUBE_API_SERVICE_NAME = 'youtube'
		@YOUTUBE_API_VERSION = 'v3'
		@YOUTUBE_ANALYTICS_API_SERVICE_NAME = 'youtubeAnalytics'
		@YOUTUBE_ANALYTICS_API_VERSION = 'v1'
		# now = Time.new.to_i
		# SECONDS_IN_DAY = 60 * 60 * 24
		# SECONDS_IN_WEEK = SECONDS_IN_DAY * 7
		# one_day_ago = Time.at(now - SECONDS_IN_DAY).strftime('%Y-%m-%d')
		# one_week_ago = Time.at(now - SECONDS_IN_WEEK).strftime('%Y-%m-%d')

		opts = Trollop::options do
		  opt :metrics, 'Report metrics', :type => String, :default => 'views,comments,favoritesAdded,favoritesRemoved,likes,dislikes,shares'
		  opt :dimensions, 'Report dimensions', :type => String, :default => 'video'
		  opt 'start-date', 'Start date, in YYYY-MM-DD format', :type => String, :default => 'one_week_ago'
		  opt 'end-date', 'Start date, in YYYY-MM-DD format', :type => String, :default => 'one_day_ago'
		  opt 'start-index', 'Start index', :type => :int, :default => 1
		  opt 'max-results', 'Max results', :type => :int, :default => 10
		  opt :sort, 'Sort order', :type => String, :default => '-views'
		end

		client = Google::APIClient.new
		youtube = client.discovered_api(@YOUTUBE_API_SERVICE_NAME, @YOUTUBE_API_VERSION)
		youtube_analytics = client.discovered_api(@YOUTUBE_ANALYTICS_API_SERVICE_NAME,
		  @YOUTUBE_ANALYTICS_API_VERSION)

		# Delete the following two lines in future if possible. We have already autheniticated using Google OAuth 2. 
		auth_util = CommandLineOAuthHelper.new(@YOUTUBE_SCOPES)
		client.authorization = auth_util.authorize()

		channels_response = client.execute!(
		  :api_method => youtube.channels.list,
		  :parameters => {
		    :mine => true,
		    :part => 'id'
		  }
		)

		channels_response.data.items.each do |channel|
		  opts[:ids] = "channel==#{channel.id}"

		  analytics_response = client.execute!(
		    :api_method => youtube_analytics.reports.query,
		    :parameters => opts
		  )

		  puts "Analytics Data for Channel #{channel.id}"

		  analytics_response.data.columnHeaders.each do |column_header|
		    printf '%-20s', column_header.name
		  end
		  puts

		  analytics_response.data.rows.each do |row|
		    row.each do |value|
		      printf '%-20s', value
		    end
		    puts
		  end
		end
	end
end
