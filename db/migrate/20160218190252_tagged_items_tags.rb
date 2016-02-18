class TaggedItemsTags < ActiveRecord::Migration
  def change
    create_table :tagged_items_tags, id: false do |t|
      t.integer :tagged_item_id, index: true
      t.integer :tag_id, index: true
    end
  end
end
