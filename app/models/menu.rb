class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_item_representations, dependent: :destroy
  has_many :menu_items, through: :menu_item_representations

  validates_presence_of :restaurant_id, :status, :title

  def print_structure
    puts '*' * 50
    menu_item_representations.roots.each do |root_item_representation|
      puts '-' * 50
      print_tree_breakdown(root_item_representation)
      puts '-' * 50
    end
    puts '*' * 50
  end

  def print_tree_breakdown(representation, depth = 0)
    puts "- " * depth + representation.menu_item.title
    return if representation.children.empty?
    representation.children.each do |child|
      print_tree_breakdown(child, depth + 1)
    end
  end
end
