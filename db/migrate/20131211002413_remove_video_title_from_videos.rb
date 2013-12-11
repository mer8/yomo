class RemoveVideoTitleFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :video_title, :string
  end
end
