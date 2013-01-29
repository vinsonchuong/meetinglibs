class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :cas_user
      t.text :token

      t.timestamps
    end
    add_index :users, :cas_user
    add_index :users, :token
  end
end
