class CreateUsersVideos < ActiveRecord::Migration
  def change
    create_table :users_videos do |t|
      t.references :user, index: true
      t.references :video, index: true
      t.string :signup_code

      t.timestamps
    end
  end
end
