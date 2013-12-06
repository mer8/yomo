class AddFbViewsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :fb_views, :integer
  end
end
