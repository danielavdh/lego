class AddStudentDetails < ActiveRecord::Migration
  def self.up
    add_column :students, :web_location1, :string
    add_column :students, :web_location2, :string
    add_column :students, :birth_date, :string
    add_column :students, :student_period, :string
    add_column :students, :pic_path, :string
    add_column :students, :pic_type, :string
    add_column :students, :pic_data, :binary
    add_column :students, :aud_paths, :text
    add_column :students, :aud_types, :text
    add_column :students, :vid_paths, :text
    add_column :students, :vid_types, :text
  end

  def self.down
    remove_column :students, :web_location1, :string
    remove_column :students, :web_location2, :string
    remove_column :students, :birth_date, :string
    remove_column :students, :student_period, :string
    remove_column :students, :pic_path, :string
    remove_column :students, :pic_type, :string
    remove_column :students, :pic_data, :binary
    remove_column :students, :aud_paths, :text
    remove_column :students, :aud_types, :text
    remove_column :students, :vid_paths, :text
    remove_column :students, :vid_types, :text
  end
end
