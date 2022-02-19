class MenuItem < ApplicationRecord
  has_many :menu_assignments, dependent: :destroy
  has_many :menus, through: :menu_assignments

  validates_presence_of :title, :price, :status
end
