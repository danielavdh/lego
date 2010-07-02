class ChangeRecDate < ActiveRecord::Migration
  def self.up
    change_column :students, :aud_recDate, :text
  end

  def self.down
    change_column :students, :aud_recDate, :date, :default => Date.new(Time.now.year, Time.now.month, Time.now.day)
  end
end
