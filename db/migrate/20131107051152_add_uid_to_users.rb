class AddUidToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :uid, :string
  	add_column :users, :name, :string
  	add_column :users, :refresh_token, :string
  	add_column :users, :access_token, :string
  	add_column :users, :expires, :string

  end
end
