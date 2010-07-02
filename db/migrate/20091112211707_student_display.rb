class StudentDisplay < ActiveRecord::Migration
  def self.up
    add_column :students, :display, :string, :default => "block"
    remove_column :students, :visibility, :string
  end

  def self.down
    remove_column :students, :display, :string
    add_column :students, :visibility, :string, :default => "visible"
  end
end
