class MenuItemVariation < ApplicationRecord
  belongs_to :parent_item, class_name: 'MenuItem'
  belongs_to :child_item,  class_name: 'MenuItem'

  validates_presence_of :parent_item_id, :child_item_id, :price_adjustment

  before_validation :set_default_price_adjustment

  def set_default_price_adjustment
    self.price_adjustment ||= child_item.try(:price) || 0
  end
end
