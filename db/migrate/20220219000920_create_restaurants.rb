#20220219000920
class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string  :city,           null: false
      t.string  :country,        null: false
      t.string  :name,           null: false
      t.string  :phone_number,   null: false
      t.string  :postal_code,    null: false
      t.string  :region,         null: false
      t.integer :status,         null: false, default: 0
      t.string  :street_address, null: false

      t.timestamps
    end
  end
end
