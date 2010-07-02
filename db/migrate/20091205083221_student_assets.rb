class StudentAssets < ActiveRecord::Migration
  def self.up
    change_column :students, :aud_paths, :string
    rename_column :students, :aud_paths, :assetsPath
  end

  def self.down
    rename_column :students, :assetsPath, :aud_paths
    change_column :students, :aud_paths, :text
  end
end
