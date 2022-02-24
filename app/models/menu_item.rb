class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :representations
  has_many :menus,  through: :representations, source: :presenter, source_type: 'Menu'
  has_many :orders, through: :representations, source: :presenter, source_type: 'Order'

  validates_presence_of :price, :restaurant_id, :status, :title
  validates :title, uniqueness: { scope: :restaurant_id }
end
