class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string  :firstname
      t.string  :lastname
      t.string  :email
      t.string  :address1
      t.string  :address2
      t.string  :address3
      t.string  :address4
      t.string  :address5
      t.string  :phone1
      t.string  :phone2
      t.string  :phone3
      t.string  :hashed_password
      t.string  :salt
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
