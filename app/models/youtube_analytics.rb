class YoutubeAnalytics

def self.trollopts
    # Parameters to get Source of Traffic
    opts={
      :metrics=>"views", 
      :dimensions=>"insightTrafficSourceDetail", 
      :filters=>"video==ypGN6H3EKOA;insightTrafficSourceType==EXT_URL", 
      "start-date"=>"2011-01-01", "end-date"=>"2013-11-11", "start-index"=>1, 
      "max-results"=>5, :sort=>"-views", 
      :help=>false, 
      :ids=>"channel==UCHjzmXcM52GFvKQxsSEuZ-g"
          }

    # Parameters to get Average Minutes Watched and Average Percentage
    popts={
      :metrics=>"views,averageViewDuration,averageViewPercentage", 
      :filters=>"video==ypGN6H3EKOA", 
      "start-date"=>"2011-01-01", 
      "end-date"=>"2013-11-11", 
      "start-index"=>1, 
      "max-results"=>5, 
      :help=>false, 
      :ids=>"channel==UCHjzmXcM52GFvKQxsSEuZ-g"
          }

    # Combine Json results from above two calls into a single hash
    {opts:opts, popts:popts}
end

end