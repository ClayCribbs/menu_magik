#20220219052333
class RemoveRestaurantNameFromMenu < ActiveRecord::Migration[7.0]
  def change
    remove_column :menus, :restaurant_name, :string
  end
end
