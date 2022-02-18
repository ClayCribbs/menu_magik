class Menu < ApplicationRecord
  validates_presence_of :title, :restaurant_name, :status
end
