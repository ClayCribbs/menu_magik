class MenuAssignment < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates_presence_of :menu_id, :menu_item_id
end
