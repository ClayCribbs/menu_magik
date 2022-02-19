class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_assignments
  has_many :menu_items, through: :menu_assignments

  validates_presence_of :restaurant_id, :status, :title
end
