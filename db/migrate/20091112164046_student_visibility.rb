class StudentVisibility < ActiveRecord::Migration
  def self.up
    add_column :students, :visibility, :string, :default => "visible"
  end

  def self.down
    remove_column :students, :visibility, :string
  end
end
