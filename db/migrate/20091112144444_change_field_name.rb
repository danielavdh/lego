class ChangeFieldName < ActiveRecord::Migration
  def self.up
    remove_column :students, :pic_path, :string
    add_column :students, :pic_name, :string, :default => "cello.jpg"
  end

  def self.down
    add_column :students, :pic_path, :string
    remove_column :students, :pic_name, :string
  end
end
