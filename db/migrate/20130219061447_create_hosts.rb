class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :hosts, :event_id
    add_index :hosts, :user_id
  end
end
