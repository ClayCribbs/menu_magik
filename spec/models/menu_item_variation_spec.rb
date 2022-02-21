require 'rails_helper'

RSpec.describe MenuItemVariation, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :parent_item_id,
                                                :child_item_id
                                              ]
  end

  context '#set_default_price_adjustment' do
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

  context '#parents' do
    it 'has many parents' do
      association_to_parents = MenuItem.reflect_on_association(:parents)
      expect(association_to_parents.macro).to eq(:has_many)
    end
  end

  context '#children' do
    it 'has many children' do
      association_to_children = MenuItem.reflect_on_association(:children)
      expect(association_to_children.macro).to eq(:has_many)
    end
  end
end
