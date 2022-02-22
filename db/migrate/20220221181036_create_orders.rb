#20220221181036
class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, index: true, foreign_key: true
      t.references :user,       null: false, index: true, foreign_key: true
      t.integer :status,        null: false, default: 0

      t.timestamps
    end
  end
end
