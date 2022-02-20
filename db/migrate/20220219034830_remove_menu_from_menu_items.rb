#20220219034830
class RemoveMenuFromMenuItems < ActiveRecord::Migration[7.0]
  def change
    remove_reference :menu_items, :menu, null: false, foreign_key: true
  end
end
