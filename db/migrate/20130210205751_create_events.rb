class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :name
      t.boolean :archived

      t.timestamps
    end
    add_index :events, :archived
  end
end
