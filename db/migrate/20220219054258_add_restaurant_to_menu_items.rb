#20220219054258
class AddRestaurantToMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :menu_items, :restaurant, null: false, foreign_key: true
    add_index     :menu_items, [:restaurant_id, :title], unique: true
  end
end
