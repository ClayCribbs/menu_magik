#20220221234618
class DropMenuAssignments < ActiveRecord::Migration[7.0]
  # I am including this migration because this table existed in master branch.
  # I would normally have a helper class that moves the data along with tests
  # but, since I have no existing data, in the interest of time I am just going
  # to drop the table

  def change
    drop_table :menu_assignments do |t|
      t.index [:menu_id, :menu_item_id], unique: true
      t.index [:menu_item_id, :menu_id], unique: true
    end
  end
end
