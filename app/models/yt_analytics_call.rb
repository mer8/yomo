class YtAnalyticsCall
	def self.traffic_call(client, yt_stuff, videoid)
	    @anaTotal={}

		youtube_analytics = client.discovered_api('youtubeAnalytics', 'v1')   

		# Traffic from Facebook
		Rails.logger.debug "**********************************************" 
		Rails.logger.debug youtube_analytics.reports.query
		analytics_response = client.execute!(
			:api_method => youtube_analytics.reports.query,
			:parameters => yt_stuff[:opts]
		)

		# Regex to parse out facebook from "http://www.facebook.com", "facebook.com", etc.
		data = analytics_response.data.rows.select do |e| 
			e[0]=~/^(https?:\/\/)?(?:www\.)?(?:facebook)?(?:\.com)?$/
		end

		result= data.flatten
		@anaTotal["facebook"] = result.map {|x| Integer(x) rescue nil }.compact.sum

	    # Traffic from Twitter
		data = analytics_response.data.rows.select do |e| 
			e[0]=~/^(https?:\/\/)?(?:www\.)?(?:youtu.be)?(?:\.com)?$/
		end
		result= data.flatten


		@anaTotal["twitter"] = result.map {|x| Integer(x) rescue nil }.compact.sum

		yt_stuff[:popts][:ids] = yt_stuff[:opts][:ids]
		yt_stuff[:popts][:filters]= "video==" + videoid.to_s
		
		# views,averageViewDuration,averageViewPercentage in this order
		analytics_response = client.execute!(
			:api_method => youtube_analytics.reports.query,
			:parameters => yt_stuff[:popts]
		)

		@anaTotal["views"] = analytics_response.data.rows.flatten[0]
		@anaTotal["averageViewDuration"] = analytics_response.data.rows.flatten[1]
		@anaTotal["averageViewPercentage"] = analytics_response.data.rows.flatten[2] 
		# puts @anaTotal

		@anaTotal
	end
end