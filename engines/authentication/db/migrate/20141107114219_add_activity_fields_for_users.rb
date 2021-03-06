class AddActivityFieldsForUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login_at,     :datetime
    add_column :users, :last_logout_at,    :datetime
    add_column :users, :last_activity_at,  :datetime
    add_column :users, :last_login_from_ip_address, :string

    add_index :users, :last_login_at
  end

  def self.down
    remove_index :users, :last_login_at

    remove_column :users, :last_activity_at
    remove_column :users, :last_logout_at
    remove_column :users, :last_login_at
    remove_column :users, :last_login_from_ip_address
  end
end
