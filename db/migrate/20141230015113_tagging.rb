class Tagging < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :topic_id
      t.integer :url_id

      t.timestamps
    end
  end
end
