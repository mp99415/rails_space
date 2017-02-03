class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.column :screen_name, :string
      t.column :email, :string
      t.column :password,:string
    end
  end
  def self.down
    drop_table :users
  end
end
