#20220221213740
class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :menu_item_representation, index: true, null: false, foreign_key: true
      t.references :order,                    index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
