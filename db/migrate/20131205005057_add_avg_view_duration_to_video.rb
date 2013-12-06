class AddAvgViewDurationToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :avg_view_duration, :integer
  end
end
