class AddTotalViewsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :total_views, :integer
  end
end
