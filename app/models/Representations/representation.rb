class Representation < ApplicationRecord
  attribute :type, :representation_sti_type

  belongs_to :menu_item
  belongs_to :presenter, polymorphic: true
  has_many :consumers

  belongs_to :consumable, polymorphic: true

  before_validation :set_default_price

  validates_uniqueness_of :menu_item_id, scope: [:parent_id, :presenter_id]

  acts_as_tree order: 'sort_order', numeric_order: true

  def set_default_price
    self.price ||= menu_item.try(:price) || 0
  end
end
