require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :restaurant_id,
                                                :status,
                                                :title,
                                              ]
  end

  context 'associations' do
    [  #model       #association
      [:restaurant, :belongs_to],
      [:menu_items, :has_many],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end

  context '#menu_items' do
    let!(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:menu)       { FactoryBot.create(:menu, restaurant: restaurant) }
    let!(:menu_item)  { FactoryBot.create(:menu_item, restaurant: restaurant) }
    let!(:menu_item2) { FactoryBot.create(:menu_item, restaurant: restaurant) }

    let!(:menu_control)      { FactoryBot.build(:menu, restaurant: restaurant) }
    let!(:menu_item_control) { FactoryBot.build(:menu_item, restaurant: restaurant) }

    before do
      menu.save!
      menu.menu_items << menu_item
      menu.menu_items << menu_item2
    end

    it 'has many menu_items' do
      expect(menu.menu_items.count).to eq(2)
    end

    context 'when creating an associated menu_item' do
      let!(:new_menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }

      it 'increases menu_items count by 1' do
        expect {
          menu.menu_items << new_menu_item
        }.to change { menu.menu_items.count }.by(1)
      end

      it 'does not increase other menu menu_items count' do
        expect {
          menu.menu_items << new_menu_item
        }.to change { menu_control.menu_items.count }.by(0)
      end
    end

    context 'when removing an associated menu_item' do
      let!(:new_menu_item) { FactoryBot.build(:menu_item, restaurant: restaurant) }

      before do
        menu.menu_items << new_menu_item
        menu.save!
      end

      it 'increases menu_items count by 1' do
        expect {
          menu.menu_items.delete(new_menu_item)
        }.to change { menu.menu_items.count }.by(-1)
      end

      it 'does not decrease other menu menu_items count' do
        expect {
          menu.menu_items.delete(new_menu_item)
        }.to change { menu_control.menu_items.count }.by(0)
      end
    end
  end
end
