require 'rails_helper'

RSpec.describe MenuItemVariation, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :parent_item_id,
                                                :child_item_id
                                              ]
  end

  describe '#set_default_price_adjustment' do
    let(:miv) { MenuItemVariation.new(parent_item: FactoryBot.create(:menu_item)) }

    before do
      miv.child_item = FactoryBot.create(:menu_item, price: 12)
    end

    context 'when price_adjustment is not provided' do
      context 'when child_item.price is populated' do
        it 'assigns child_item.price to price_adjustment' do
          expect(miv).to be_valid
          expect(miv.price_adjustment).to eq(12)
        end
      end

      context 'when child.price is nil' do
        before do
          allow_any_instance_of(MenuItem).to receive(:price).and_return(nil)
        end

        it 'assigns 0 to price_adjustment' do
          expect(miv).to be_valid
          expect(miv.price_adjustment).to eq(0)
        end
      end
    end

    context 'when a price_adjustment is provided' do
      before do
        miv.price_adjustment = 6
      end

      context 'when child_item.price is populated' do
        it 'assigns the provided value to price_adjustment' do
          expect(miv).to be_valid
          expect(miv.price_adjustment).to eq(6)
        end
      end

      context 'when child.price is nil' do
        before do
          allow_any_instance_of(MenuItem).to receive(:price).and_return(nil)
        end

        it 'assigns the provided value to price_adjustment' do
          expect(miv).to be_valid
          expect(miv.price_adjustment).to eq(6)
        end
      end
    end
  end

  describe '#menu' do
    it 'belongs_to menu' do
      association_to_menu = MenuItemVariation.reflect_on_association(:menu)
      expect(association_to_menu.macro).to eq(:belongs_to)
    end

    it 'is not required' do
      menu_item_variation = FactoryBot.build(:menu_item_variation)
      menu_item_variation.menu = nil
      expect(menu_item_variation).to be_valid
      expect(menu_item_variation.menu_id).to eq(nil)
    end
  end

  describe '#parent_item' do
    it 'belongs_to parent_item' do
      association_to_parent_item = MenuItemVariation.reflect_on_association(:parent_item)
      expect(association_to_parent_item.macro).to eq(:belongs_to)
    end
  end

  describe '#child_item' do
    it 'belongs to child_item' do
      association_to_child_item = MenuItemVariation.reflect_on_association(:child_item)
      expect(association_to_child_item.macro).to eq(:belongs_to)
    end
  end
end
