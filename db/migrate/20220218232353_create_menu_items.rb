#20220218232353
class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.references :menu,       null: false,  foreign_key: true
      t.string     :title,      null: false
      t.integer    :status,     null: false,  default: 0
      t.decimal    :price,      precision: 8, scale: 2
      t.text       :description

      t.timestamps
    end
  end
end
