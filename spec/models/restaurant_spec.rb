require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :city,
                                                :country,
                                                :name,
                                                :phone_number,
                                                :postal_code,
                                                :region,
                                                :status,
                                                :street_address,
                                              ]
  end

  describe '#menus' do
    it 'has many menus' do
      association_to_menus = Restaurant.reflect_on_association(:menus)
      expect(association_to_menus.macro).to eq(:has_many)
    end
  end

  describe '#menu_items' do
    it 'has many menu_items' do
      association_to_menu_items = Restaurant.reflect_on_association(:menu_items)
      expect(association_to_menu_items.macro).to eq(:has_many)
    end
  end
end
