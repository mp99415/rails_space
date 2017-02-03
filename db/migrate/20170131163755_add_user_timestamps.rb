class AddUserTimestamps < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :created_at, :timestamp
    add_column :users, :updated_at, :timestamp
  end
  def self.down
    remove_column :users,:created_at
    remove_column :users,:updated_at
  end
end
