class Restaurant < ApplicationRecord
  validates_presence_of :name, :street_address, :city, :region, :country, :postal_code, :phone_number, :status
end
