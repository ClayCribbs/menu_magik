class Menu < ApplicationRecord
  has_many :menu_items

  validates_presence_of :title, :restaurant_name, :status
end
