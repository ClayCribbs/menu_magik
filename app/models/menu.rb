class Menu < ApplicationRecord
  has_many :menu_items

  validates_presence_of :restaurant_name, :status, :title
end
