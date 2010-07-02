# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100430132123) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.datetime "publish_date"
    t.datetime "concert_date"
    t.string   "publisher"
    t.string   "author"
    t.string   "venue"
    t.string   "artists"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
    t.string   "display"
  end

  create_table "downloads", :force => true do |t|
    t.string   "comment"
    t.string   "name"
    t.string   "content_type"
    t.binary   "data",         :limit => 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "language"
    t.string   "event_type"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "line_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "address5"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "phone3"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "after_school",    :default => false
    t.string   "web_location1"
    t.string   "web_location2"
    t.string   "birth_date"
    t.string   "student_period"
    t.string   "pic_type"
    t.binary   "pic_data"
    t.string   "assetsPath"
    t.text     "aud_titles"
    t.text     "vid_paths"
    t.text     "vid_descr"
    t.string   "pic_name",        :default => "cello.jpg"
    t.string   "displayed",       :default => "block"
    t.text     "aud_recDate",     :default => "2009-12-05"
  end

end
