class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end
    add_index :visitors, :event_id
    add_index :visitors, :user_id
  end
end
