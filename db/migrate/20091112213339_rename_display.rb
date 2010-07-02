class RenameDisplay < ActiveRecord::Migration
  def self.up
    rename_column :students, :display, :displayed
  end

  def self.down
    rename_column :students, :displayed, :display
  end
end
