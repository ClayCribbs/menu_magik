#20220220191843
class CreateMenuItemRepresentations < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_item_representations do |t|
      t.references :menu_item,        null: false, index: true
      t.references :menu,             null: false, index: true
      t.integer    :parent_id,        index: true
      t.decimal    :price_adjustment, precision: 8, scale: 2
      t.integer    :sort_order,       null: false, default: 0
      t.timestamps
    end

    add_index :menu_item_representations, [:parent_id, :menu_item_id, :menu_id],
      unique: true,
      name: "menu_item_representations_pid_miid_mid"
  end
end
