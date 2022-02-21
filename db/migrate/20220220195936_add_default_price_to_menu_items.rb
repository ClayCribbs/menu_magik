#20220220195936
class AddDefaultPriceToMenuItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :menu_items, :price, 0
    change_column_null    :menu_items, :price, false
  end
end
