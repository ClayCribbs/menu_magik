class MenuItemRepresentation < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  before_validation :set_default_price_adjustment

  validates_presence_of :menu_item_id, :menu_id, :price_adjustment
  validates_uniqueness_of :menu_item_id, scope: [:parent_id, :menu_id]

  acts_as_tree order: 'sort_order', numeric_order: true

  def add_to_order(order)
    order.create_order_items_from_menu_item_representation(self)
  end

  def set_default_price_adjustment
    self.price_adjustment ||= menu_item.try(:price) || 0
  end
end
