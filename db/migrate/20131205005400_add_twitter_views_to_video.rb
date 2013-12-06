class AddTwitterViewsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :twitter_views, :integer
  end
end
