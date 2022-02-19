require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#validations' do
    it 'is valid if required fields are present' do
      restaurant = build(:restaurant)

      expect(restaurant).to be_valid
      expect(restaurant.errors).to be_empty
    end

    [ #required field
      :city,
      :country,
      :name,
      :phone_number,
      :postal_code,
      :region,
      :status,
      :street_address,
    ].each do |required_field|
      it "is invalid if #{required_field} is not present" do
        restaurant = build(:restaurant)
        restaurant.send("#{required_field}=", '')

        expect(restaurant).not_to be_valid
        expect(restaurant.errors).to have_key(required_field)
      end

      it "is invalid if #{required_field} is set to nil" do
        restaurant = build(:restaurant)
        restaurant.send("#{required_field}=", nil)

        expect(restaurant).not_to be_valid
        expect(restaurant.errors).to have_key(required_field)
      end
    end
  end
end
