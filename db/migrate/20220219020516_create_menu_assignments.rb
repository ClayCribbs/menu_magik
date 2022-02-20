#20220219020516
class CreateMenuAssignments < ActiveRecord::Migration[7.0]
  def change
    create_join_table :menu_items, :menus, table_name: :menu_assignments do |t|
      t.index [:menu_id, :menu_item_id], unique: true
      t.index [:menu_item_id, :menu_id], unique: true
    end
  end
end
