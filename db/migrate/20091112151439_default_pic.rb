class DefaultPic < ActiveRecord::Migration
  def self.up
    change_column :students, :pic_name, :string, :default => "cello.jpg"
  end

  def self.down
    change_column :students, :pic_name, :string
  end
end
