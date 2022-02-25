class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_item_representations, dependent: :destroy
  has_many :menus, through: :menu_item_representations

  validates_presence_of :price, :restaurant_id, :status, :title
  validates :title, uniqueness: { scope: :restaurant_id }
end
