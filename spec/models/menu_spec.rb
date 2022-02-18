require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#validations' do
    it 'is valid if required fields are present' do
      menu = build(:menu)

      expect(menu).to be_valid
      expect(menu.errors).to be_empty
    end

    [ #required field
      :title,
      :restaurant_name,
      :status
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
end
