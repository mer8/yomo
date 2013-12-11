class DropSocialPlatformTotals < ActiveRecord::Migration
  def change
  	drop_table :social_platform_totals
  end
end
