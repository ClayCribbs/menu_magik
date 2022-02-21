#20220220191843
class CreateMenuItemVariations < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_item_variations do |t|
      t.references :parent_item, null: false, index: true, foreign_key: { to_table: :menu_items }
      t.references :child_item,  null: false, index: true, foreign_key: { to_table: :menu_items }
      t.decimal    :price_adjustment, precision: 8, scale: 2
      t.timestamps
    end
  end
end
