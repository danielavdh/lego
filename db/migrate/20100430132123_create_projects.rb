class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :language
      t.string :event_type
      t.datetime :start_date
      t.datetime :end_date
      t.string :line_1
      t.string :line_2
      t.string :line_3
      t.string :line_4
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
