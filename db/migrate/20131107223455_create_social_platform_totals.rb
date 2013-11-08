class CreateSocialPlatformTotals < ActiveRecord::Migration
  def change
    create_table :social_platform_totals do |t|
      t.integer :num_views
      t.string :platform
      t.references :video, index: true
      t.date :day

      t.timestamps
    end
  end
end
