class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.datetime :publish_date
      t.datetime :concert_date
      t.string :publisher
      t.string :author
      t.string :venue
      t.string :artists
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
