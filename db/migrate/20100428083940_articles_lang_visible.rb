class ArticlesLangVisible < ActiveRecord::Migration
  def self.up
    add_column :articles, :language, :string
    add_column :articles, :display, :string
  end

  def self.down
    remove_column :articles, :language, :string
    remove_column :articles, :display, :string
end
end
