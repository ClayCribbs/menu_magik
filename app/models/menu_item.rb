class MenuItem < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_assignments, dependent: :destroy
  has_many :menus, through: :menu_assignments

  has_many :parent_items,
            class_name: 'MenuItemVariation',
            foreign_key: :child_item_id,
            dependent: :destroy
  has_many :child_items,
            class_name: 'MenuItemVariation',
            foreign_key: :parent_item_id,
            dependent: :destroy

  has_many :parents,  through: :parent_items, source: :parent_item
  has_many :children, through: :child_items,  source: :child_item

  validates_presence_of :restaurant_id, :title, :price, :status
  validates :title, uniqueness: { scope: :restaurant_id }
end
