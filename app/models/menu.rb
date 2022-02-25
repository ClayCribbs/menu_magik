class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_item_representations, dependent: :destroy
  has_many :menu_items, through: :menu_item_representations

  validates_presence_of :restaurant_id, :status, :title
end
