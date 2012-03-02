class AddMergeArticles < ActiveRecord::Migration
  def self.up
    create_table :merged_authors do |t|
      t.integer "user_id"
      t.integer "article_id"
    end
  end

  def self.down
    drop_table :merged_authors
  end
end
