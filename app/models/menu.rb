class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :representations, as: :presenter
  has_many :menu_items, through: :representations

  validates_presence_of :restaurant_id, :status, :title
end
