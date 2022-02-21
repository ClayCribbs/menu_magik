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

  def create_child(passed_attributes = {})
    merged_attributes = inheritable_attributes.merge(passed_attributes)
    children << MenuItem.create(merged_attributes)
    save!
  end

  private

  def inheritable
    %w(title price restaurant_id)
  end

  def inheritable_attributes
    self.attributes.slice(*inheritable).symbolize_keys
  end
end
