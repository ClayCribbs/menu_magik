class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy
  has_many :menu_item_representations, through: :order_items, source: :menu_item_representation

  validates_presence_of :status, :restaurant_id, :user_id

  def create_order_items_from_menu_item_representation(mir)
    self.menu_item_representations = (self.menu_item_representations + mir.self_and_ancestors).uniq
    self.save!
  end

  def print_structure
    puts '*' * 50
    menu_item_representations.roots.each do |root_item|
      puts '-' * 50
      print_tree_breakdown(root_item)
      puts '-' * 50
    end
    puts '*' * 50
  end

  def print_tree_breakdown(item, depth = 0)
    puts "-" * depth + item.menu_item.title
    children_to_create = item.children.where(id: menu_item_representations.pluck(:id)).all
    return if children_to_create.empty?
    children_to_create.each do |child_to_create|
      print_tree_breakdown(child_to_create, depth + 1)
    end
  end
end
