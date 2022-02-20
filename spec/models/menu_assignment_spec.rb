require 'rails_helper'

RSpec.describe MenuAssignment, type: :model do
  describe '#validate' do
    it 'is valid if required fields are present' do
      menu_assignment = build(:menu_assignment)
      expect(menu_assignment).to be_valid
      expect(menu_assignment.errors).to be_empty
    end

    [ #required field
      :menu_id,
      :menu_item_id
    ].each do |required_field|
      it "is invalid if #{required_field} is not present" do
        menu_assignment = build(:menu_assignment)
        menu_assignment.send("#{required_field}=", '')

        expect(menu_assignment).not_to be_valid
        expect(menu_assignment.errors).to have_key(required_field)
      end

      it "is invalid if #{required_field} is set to nil" do
        menu_assignment = build(:menu_assignment)
        menu_assignment.send("#{required_field}=", nil)

        expect(menu_assignment).not_to be_valid
        expect(menu_assignment.errors).to have_key(required_field)
      end
    end
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
