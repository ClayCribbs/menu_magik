require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe '#validate' do
    it 'is valid if required fields are present' do
      menu_item = build(:menu_item)

      expect(menu_item).to be_valid
      expect(menu_item.errors).to be_empty
    end

    [ #required field
      :price,
      :restaurant_id,
      :status,
      :title,
    ].each do |required_field|
      it "is invalid if #{required_field} is not present" do
        menu_item = build(:menu_item)
        menu_item.send("#{required_field}=", '')

        expect(menu_item).not_to be_valid
        expect(menu_item.errors).to have_key(required_field)
      end

      it "is invalid if #{required_field} is set to nil" do
        menu_item = build(:menu_item)
        menu_item.send("#{required_field}=", nil)

        expect(menu_item).not_to be_valid
        expect(menu_item.errors).to have_key(required_field)
      end
    end

    context 'with same title as an existing MenuItem' do
      let(:existing_menu_item) { FactoryBot.create(:menu_item, title: 'Example') }

      context 'that shares the same restaurant' do
        it 'is not valid' do
          menu_item = build(:menu_item,
                             title: 'Example',
                             restaurant: existing_menu_item.restaurant)

          expect(menu_item).not_to be_valid
          expect(menu_item.errors).to have_key(:title)
        end
      end

      context 'that does not share the same restaurant' do
        it 'is valid' do
          menu_item = build(:menu_item,
                             title: 'Example',
                             restaurant: FactoryBot.create(:restaurant))

          expect(menu_item).to be_valid
          expect(menu_item.errors).to be_empty
        end
      end
    end
  end

  context 'associations' do
    it 'has_many menus' do
      association_to_menus = MenuItem.reflect_on_association(:menus)
      expect(association_to_menus.macro).to eq(:has_many)
    end

    it 'belongs to restaurant' do
      association_to_restaurant = MenuItem.reflect_on_association(:restaurant)
      expect(association_to_restaurant.macro).to eq(:belongs_to)
    end
  end
end
