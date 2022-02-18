class MenuItem < ApplicationRecord
  belongs_to :menu

  validates_presence_of :menu_id, :title, :price, :status
end
