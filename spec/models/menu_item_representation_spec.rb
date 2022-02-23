require 'rails_helper'

RSpec.describe MenuItemRepresentation, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :menu_id,
                                                :menu_item_id
                                              ]

    describe 'add_to_order' do
      let(:mir) { FactoryBot.create(:menu_item_representation) }

      context 'with an order that is nil' do
        it 'fails' do
          expect {
            mir.add_to_order(nil)
          }.to raise_error
        end
      end

      context 'with a valid order' do
        let(:order) { FactoryBot.create(:order) }

        context 'with a menu_item_representation that has no children or parents' do
          it 'creates a valid and associated order_item' do
            expect {
              mir.add_to_order(order)
            }.to change { OrderItem.count }.by(1)
          end
        end

        context 'with a menu_item_representation that has an ancestry' do


          context 'that include other children' do
            it 'creates a valid and associated order_item for each parent' do
              expect {
                mir.add_to_order(order)
              }.to change { OrderItem.count }.by(3)
            end
          end

          context 'that do not include other children' do
            it 'creates a valid and associated order_item for each parent' do
              expect {
                mir.add_to_order(order)
              }.to change { OrderItem.count }.by(3)
            end
          end
        end

        context 'with a menu_item_representations that has no parent' do
          context 'that also has a parent' do
            it 'creates a valid and associated order_item' do
              expect {
                mir.add_to_order(order)
              }.to change { OrderItem.count }.by(1)
            end
          end

          context 'that do not include other parents' do
            it 'creates a valid and associated order_item' do
              expect {
                mir.add_to_order(order)
              }.to change { OrderItem.count }.by(1)
            end
          end
        end
      end
    end

    context 'uniqueness' do
      context 'given an existing MenuItemRepresentation' do
        let!(:menu_item_representation) { FactoryBot.create(:menu_item_representation, :with_parent) }
        let(:menu)                      { menu_item_representation.menu }
        let(:menu_item)                 { menu_item_representation.menu_item }
        let(:parent)                    { menu_item_representation.parent }
        let(:mir)                       { FactoryBot.build(:menu_item_representation,
                                                            parent:    nil,
                                                            menu:      nil,
                                                            menu_item: nil) }

        context 'that shares no attributes' do
          it 'is valid' do
            expect(FactoryBot.build(:menu_item_representation, :with_parent)).to be_valid
          end
        end

        context 'that shares the same menu and parent' do
          before do
            mir.menu_item = FactoryBot.create(:menu_item)
            mir.menu      = menu
            mir.parent    = parent
          end

          it 'is valid' do
            expect(mir).to be_valid
          end
        end

        context 'that shares the same menu_item and parent' do
          before do
            mir.menu      = FactoryBot.create(:menu)
            mir.menu_item = menu_item
            mir.parent    = parent
          end

          it 'is valid' do
            expect(mir).to be_valid
          end
        end

        context 'that shares the same menu and menu_item' do
          before do
            mir.parent    = FactoryBot.create(:menu_item_representation)
            mir.menu      = menu
            mir.menu_item = menu_item
          end

          it 'is valid' do
            expect(mir).to be_valid
          end
        end

        context 'that shares the same menu and menu_item and parent' do
          before do
            mir.menu      = menu
            mir.menu_item = menu_item
            mir.parent    = parent
          end

          it 'is not valid' do
            expect(mir).not_to be_valid
          end
        end
      end
    end
  end

  context 'associations' do
    [  #model       #association
      [:menu,        :belongs_to],
      [:menu_item,   :belongs_to],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end

  describe '#set_default_price_adjustment' do
    let(:mir) { FactoryBot.create(:menu_item_representation) }

    context 'when price_adjustment is not provided' do
      before do
        mir.price_adjustment = nil
      end

      context 'when menu_item.price is populated' do
        before do
          mir.menu_item.price = 12.00
        end

        it 'assigns menu_item.price to price_adjustment' do
          expect(mir).to be_valid
          expect(mir.price_adjustment.to_s).to eq('12.0')
        end
      end

      context 'when menu_item.price is nil' do
        before do
          allow_any_instance_of(MenuItem).to receive(:price).and_return(nil)
        end

        it 'assigns 0 to price_adjustment' do
          expect(mir).to be_valid
          expect(mir.price_adjustment.to_s).to eq('0.0')
        end
      end
    end

    context 'when a price_adjustment is provided' do
      before do
        mir.price_adjustment = 6
      end

      context 'when menu_item.price is populated' do
        it 'assigns the provided value to price_adjustment' do
          expect(mir).to be_valid
          expect(mir.price_adjustment.to_s).to eq('6.0')
        end
      end

      context 'when menu_item.price is nil' do
        before do
          allow_any_instance_of(MenuItem).to receive(:price).and_return(nil)
        end

        it 'assigns the provided value to price_adjustment' do
          expect(mir).to be_valid
          expect(mir.price_adjustment.to_s).to eq('6.0')
        end
      end
    end
  end
end
