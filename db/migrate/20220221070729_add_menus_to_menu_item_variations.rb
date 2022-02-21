#20220221070729
class AddMenusToMenuItemVariations < ActiveRecord::Migration[7.0]
  def change
    add_reference :menu_item_variations, :menu, foreign_key: true
  end
end
