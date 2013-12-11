class DropChannelsUsers < ActiveRecord::Migration
  def change
  	drop_table :channels_users
  end
end
