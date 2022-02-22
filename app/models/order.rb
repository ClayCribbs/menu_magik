class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :order_items

  validates_presence_of :status, :restaurant_id, :user_id
end
