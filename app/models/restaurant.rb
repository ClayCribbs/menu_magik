class Restaurant < ApplicationRecord
  validates_presence_of :city, :country, :name, :phone_number, :postal_code,
  :region, :status, :street_address
end
