class Video < ActiveRecord::Base
# require 'google/api_client'
	has_many :social_platform_totals
end
