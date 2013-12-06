class AddAvgViewPctToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :avg_view_pct, :integer
  end
end
