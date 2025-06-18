class DropNotifications < ActiveRecord::Migration[8.0]
  def up
    if table_exists?(:notifications)
      drop_table :notifications
    end
  end

  def down
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.string :message
      t.boolean :read, default: false
      
      t.timestamps
    end
  end
end
