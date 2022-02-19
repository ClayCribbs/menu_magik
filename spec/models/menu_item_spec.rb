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
  end

  context 'associations' do
    it 'belongs to menu' do
      association_to_menu = MenuItem.reflect_on_association(:menus)
      expect(association_to_menu.macro).to eq(:has_many)
    end
  end
end
