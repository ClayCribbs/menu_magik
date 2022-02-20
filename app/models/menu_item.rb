class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_assignments, dependent: :destroy
  has_many :menus, through: :menu_assignments

  validates_presence_of :restaurant_id, :title, :price, :status
  validates :title, uniqueness: { scope: :restaurant_id }
end
