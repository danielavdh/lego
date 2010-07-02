class AfterSchool < ActiveRecord::Migration
  def self.up
    add_column :students, :after_school, :boolean, :default => false
  end

  def self.down
    remove_column :students, :after_school, :boolean, :default => false
  end
end
