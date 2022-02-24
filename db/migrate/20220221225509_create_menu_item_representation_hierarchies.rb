#20220221225509
class CreateMenuItemRepresentationHierarchies < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_item_representation_hierarchies, id: false do |t|
      t.integer :ancestor_id,   null: false
      t.integer :descendant_id, null: false
      t.integer :generations,   null: false
    end

    add_index :menu_item_representation_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "menu_item_representation_anc_desc_idx"

    add_index :menu_item_representation_hierarchies, [:descendant_id],
      name: "menu_item_representation_desc_idx"
  end
end
