require 'rails_helper'

RSpec.describe MenuItemVariation, type: :model do
  describe '#validate' do
    it 'is valid if required fields are present' do
      menu_item_variation = build(:menu_item_variation)
      expect(menu_item_variation).to be_valid
      expect(menu_item_variation.errors).to be_empty
    end

    [ #required field
      :parent_item_id,
      :child_item_id
    ].each do |required_field|
      it "is invalid if #{required_field} is not present" do
        menu_item_variation = build(:menu_item_variation)
        menu_item_variation.send("#{required_field}=", '')

        expect(menu_item_variation).not_to be_valid
        expect(menu_item_variation.errors).to have_key(required_field)
      end

      it "is invalid if #{required_field} is set to nil" do
        menu_item_variation = build(:menu_item_variation)
        menu_item_variation.send("#{required_field}=", nil)

        expect(menu_item_variation).not_to be_valid
        expect(menu_item_variation.errors).to have_key(required_field)
      end
    end
  end

  context '#parents' do
    it 'has many parents' do
      association_to_parents = MenuItem.reflect_on_association(:parents)
      expect(association_to_parents.macro).to eq(:has_many)
    end
  end

  contex '#children' do
    it 'has many children' do
      association_to_children = MenuItem.reflect_on_association(:children)
      expect(association_to_children.macro).to eq(:has_many)
    end
  end
end
