class AddVideoTitleToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :video_title, :string
  end
end
