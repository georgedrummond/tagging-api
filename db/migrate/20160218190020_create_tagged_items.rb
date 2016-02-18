class CreateTaggedItems < ActiveRecord::Migration
  def change
    create_table :tagged_items do |t|
      t.string :entity_type
      t.string :entity_identifier
      t.timestamps null: false
    end
  end
end
