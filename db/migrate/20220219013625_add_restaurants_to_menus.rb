#20220219013625
class AddRestaurantsToMenus < ActiveRecord::Migration[7.0]
  def change
    add_reference :menus, :restaurant, null: false, foreign_key: true
  end
end
