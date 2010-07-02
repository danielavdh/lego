class RenameVidTypes < ActiveRecord::Migration
  def self.up
    rename_column :students, :vid_types, :vid_descr
  end

  def self.down
    rename_column :students, :vid_descr, :vid_types
  end
end
