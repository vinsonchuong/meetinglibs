class AddContactInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :text
    add_column :users, :last_name, :text
    add_column :users, :email, :text
  end
end
