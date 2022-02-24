#20220220191843
class CreateRepresentations < ActiveRecord::Migration[7.0]
  def change
    create_table :representations do |t|
      t.references :menu_item,      null: false, index: true
      t.references :menu,           null: false, index: true
      t.integer    :parent_id,      index: true
      t.string     :presenter_type, null: false, index: true
      t.decimal    :price,          precision: 8, scale: 2
      t.integer    :sort_order,     null: false, default: 0
      t.string     :type,           null: false
      t.timestamps
    end

    add_index :representations, [:menu_item_id, :presenter_id, :parent_id, :type],
      unique: true,
      name: 'representations_rep_men_par_typ'
  end
end
