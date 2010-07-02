class StudentCodes < ActiveRecord::Migration
  def self.up
    rename_column :students, :aud_types, :aud_titles
    add_column :students, :aud_recDate, :date, :default => Date.new(Time.now.year, Time.now.month, Time.now.day)

  end

  def self.down
    rename_column :students, :aud_titles, :aud_types
    remove_column :students, :aud_recDate
  end
end
