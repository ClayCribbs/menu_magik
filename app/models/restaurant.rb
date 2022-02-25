class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  has_many :menu_items, dependent: :destroy

  validates_presence_of :city, :country, :name, :phone_number, :postal_code,
  :region, :status, :street_address
end
