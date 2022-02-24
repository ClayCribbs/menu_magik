class OrderItem < ApplicationRecord
  belongs_to :menu_item_representation
  belongs_to :order

  validates_presence_of :menu_item_representation_id, :order_id
end
