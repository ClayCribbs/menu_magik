class User < ApplicationRecord
  has_many :orders

  validates_presence_of :city, :country, :name, :phone_number, :postal_code,
  :region, :status, :street_address
end
