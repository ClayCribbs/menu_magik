require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#validate' do
    it 'is valid if required fields are present' do
      menu = build(:menu)

      expect(menu).to be_valid
      expect(menu.errors).to be_empty
    end

    [ #required field
      :restaurant_id,
      :status,
      :title,
    ].each do |required_field|
      it "is invalid if #{required_field} is not present" do
        menu = build(:menu)
        menu.send("#{required_field}=", '')

        expect(menu).not_to be_valid
        expect(menu.errors).to have_key(required_field)
      end

      it "is invalid if #{required_field} is set to nil" do
        menu = build(:menu)
        menu.send("#{required_field}=", nil)

        expect(menu).not_to be_valid
        expect(menu.errors).to have_key(required_field)
      end
    end
  end

  context 'associations' do
    it 'belongs to restaurant' do
      association_to_restaurant = Menu.reflect_on_association(:restaurant)
      expect(association_to_restaurant.macro).to eq(:belongs_to)
    end

    it 'has many menu_items' do
      association_to_menu_items = Menu.reflect_on_association(:menu_items)
      expect(association_to_menu_items.macro).to eq(:has_many)
    end
  end
end
