#20220218224640
class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string  :restaurant_name, null: false
      t.integer :status,          null: false, default: 0
      t.string  :title,           null: false

      t.timestamps
    end
  end
end
