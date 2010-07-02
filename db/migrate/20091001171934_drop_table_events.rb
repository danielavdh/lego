class DropTableEvents < ActiveRecord::Migration
  def self.up
    drop_table :events
  end

  def self.down
    create_table :events do |t|
      t.string :name
      t.string :color
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
