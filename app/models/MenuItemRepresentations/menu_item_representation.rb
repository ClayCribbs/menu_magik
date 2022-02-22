class MenuItemRepresentation < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  before_validation :set_default_price_adjustment

  validates_presence_of :menu_item_id, :menu_id, :price_adjustment
  validates_uniqueness_of :menu_item_id, scope: [:parent_id, :menu_id]

  acts_as_tree order: 'sort_order', numeric_order: true

  def set_default_price_adjustment
    self.price_adjustment ||= menu_item.try(:price) || 0
  end

  def create_child_from_menu_item(child_menu_item)
    mir = MenuItemRepresentation.where( menu_item_id: child_menu_item.id,
                                        menu_id:      menu_id,
                                        parent_id:    id
                                      ).first_or_create
    self.add_child(mir)
    save!
    mir
  end

  def print_structure(depth = 0)
    puts "-" * depth + menu_item.title
    return if children.empty?
    children.each do |child|
      child.print_structure(depth + 1)
    end
  end
end
