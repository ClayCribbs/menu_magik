require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe '#validations' do
    it 'is valid if required fields are present' do
      menu_item = build(:menu_item)

      expect(menu_item).to be_valid
      expect(menu_item.errors).to be_empty
    end

    [ #required field
      :menu_id,
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

  describe '#associations' do
    it 'belongs to menu' do
      association_to_menu = MenuItem.reflect_on_association(:menu)
      expect(association_to_menu.macro).to eq(:belongs_to)
    end
  end
end
