require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :restaurant_id,
                                                :status,
                                                :title,
                                              ]
  end

  describe '#restaurant' do
    it 'belongs to restaurant' do
      association_to_restaurant = Menu.reflect_on_association(:restaurant)
      expect(association_to_restaurant.macro).to eq(:belongs_to)
    end
  end

  describe '#menu_items' do
    it 'has many menu_items' do
      association_to_menu_items = Menu.reflect_on_association(:menu_items)
      expect(association_to_menu_items.macro).to eq(:has_many)
    end
  end
end
