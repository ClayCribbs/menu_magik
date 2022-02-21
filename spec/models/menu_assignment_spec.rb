require 'rails_helper'

RSpec.describe MenuAssignment, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :menu_id,
                                                :menu_item_id
                                              ]
  end

  context '#menu' do
    it 'belongs to menu' do
      association_to_menu = MenuAssignment.reflect_on_association(:menu)
      expect(association_to_menu.macro).to eq(:belongs_to)
    end
  end

  context '#menu_item' do
    it 'belongs to menu_item' do
      association_to_menu_item = MenuAssignment.reflect_on_association(:menu_item)
      expect(association_to_menu_item.macro).to eq(:belongs_to)
    end
  end
end
