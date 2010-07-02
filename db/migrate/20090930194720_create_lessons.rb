class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      t.string :name
      t.string :color
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end

  def self.down
    drop_table :lessons
  end
end
