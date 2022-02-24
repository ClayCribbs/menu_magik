class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  has_many :representations, as: :presenter
  has_many :order_items, through: :representations

  validates_presence_of :status, :restaurant_id, :user_id

  def subtotals
    representations.roots.map(&:subtotal_for)
  end

  def total
    subtotals.sum
  end

  def subtotal_for(representation)
    order_items.where(id: representation.self_and_descendants.pluck(:id))
               .sum(:price)
               .to_s
  end

#### Methods for debugging

  def print_structure
    representations.roots.each do |root_representation|
      print_item_summary(root_representation)
    end
    nil
  end

  def print_item_summary(root_representation)
    print_item_total(root_representation)
    print_tree_breakdown(root_representation)
  end

  def print_item_total(root_representation)
    puts "#{root_representation.menu_item.title} -- Total: #{subtotal_for(root_representation)}"
  end

  def print_tree_breakdown(representation, depth = 0)
    puts "-" * depth + representation.menu_item.title
    children_to_create = representation.children.where(id: representations.pluck(:id)).all
    return if children_to_create.empty?
    children_to_create.each do |child_to_create|
      print_tree_breakdown(child_to_create, depth + 1)
    end
  end
end
