require 'rails_helper'

RSpec.describe MenuItemRepresentation, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :menu_id,
                                                :menu_item_id
                                              ]
    context 'associations' do
      [  #model       #association
        [:menu,        :belongs_to],
        [:menu_item,   :belongs_to],
      ].each do |model, association|
        include_examples 'associates_with', model, association
      end
    end

    context 'uniqueness' do
      describe '#menu_item_id' do
        context 'when verifying it is scoped to :parent_id, :menu_id' do
          context 'with an existing menu_item_representation' do
            let!(:menu_item_representation) { FactoryBot.create(:menu_item_representation) }
            let(:menu)                      { menu_item_representation.menu }
            let(:menu_item)                 { menu_item_representation.menu_item }
            let(:parent)                    { menu_item_representation.parent }
            let(:mir)                       { FactoryBot.build(:menu_item_representation,
                                                                parent:    parent,
                                                                menu:      menu,
                                                                menu_item: menu_item) }

            context 'that shares no attributes' do
              it 'is valid' do
                expect(FactoryBot.build(:menu_item_representation)).to be_valid
              end
            end

            context 'that shares the same menu and parent' do
              before do
                mir.menu_item = FactoryBot.create(:menu_item)
              end

              it 'is valid' do
                expect(mir).to be_valid
              end
            end

            context 'that shares the same menu_item and parent' do
              before do
                mir.menu = FactoryBot.create(:menu)
              end

              it 'is valid' do
                expect(mir).to be_valid
              end
            end

            context 'that shares the same menu and menu_item' do
              before do
                mir.parent = FactoryBot.create(:menu_item_representation)
              end

              it 'is valid' do
                expect(mir).to be_valid
              end
            end

            context 'that shares the same menu and menu_item and parent' do
              it 'is not valid' do
                expect(mir).not_to be_valid
              end
            end
          end
        end
      end
    end
  end

  describe '#add_to_order' do
    let(:mir) { FactoryBot.create(:menu_item_representation) }

    context 'with an order that is nil' do
      it 'fails' do
        expect {
          mir.add_to_order(nil)
        }.to raise_error(NoMethodError)
      end
    end

    context 'with a valid order' do
      let(:order) { FactoryBot.create(:order) }

      context 'with no children or parents' do
        it 'creates an associated order_item' do
          expect(mir.parent).to eq(nil)
          expect(mir.children).to be_empty
          expect {
            mir.add_to_order(order)
          }.to change { OrderItem.count }.by(1)
        end
      end

      context 'with a populated family tree' do
        include_context 'with a namespaced menu_item_representation tree'

        context 'where no ancestors share the order' do
          context 'where children share the order' do
            before do
              child.add_to_order(order)
            end

            it 'does not create an order_item' do
              expect(order.menu_item_representations).to include(established_mir)
              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item for each ancestor that has none' do
              expected_count = established_mir.self_and_ancestors.count

              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(expected_count)
            end
          end
        end

        context 'where some ancestors share the order' do
          before do
            grandparent.add_to_order(order)
          end

          context 'where children share the order' do
            before do
              child.add_to_order(order)
            end

            it 'does not create an order_itemr' do
              expect(order.menu_item_representations).to include(established_mir)
              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item for each ancestor that has none' do
              existing_order_items = order.order_items
                                      .pluck(:menu_item_representation_id)
              expected_count       = established_mir.self_and_ancestors
                                      .where('id NOT IN (?)', existing_order_items)
                                      .count

              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(expected_count)
            end
          end
        end

        context 'where all ancestors share the order' do
          before do
            parent.add_to_order(order)
          end

          context 'where children share the order' do
            before do
              child.add_to_order(order)
            end

            it 'does not create an order_item' do
              expect(order.menu_item_representations).to include(established_mir)
              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item' do
              expect(mir.parent).to eq(nil)
              expect(mir.children).to be_empty
              expect {
                established_mir.add_to_order(order)
              }.to change { OrderItem.count }.by(1)
            end
          end
        end

        context 'where a granduncle shares the order' do
          before do
            granduncle.add_to_order(order)
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = (established_mir.self_and_ancestors - granduncle.self_and_ancestors).count

            expect {
              established_mir.add_to_order(order)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end

        context 'where a nephew shares the order' do
          before do
            nephew.add_to_order(order)
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = (established_mir.self_and_ancestors - nephew.self_and_ancestors).count

            expect {
              established_mir.add_to_order(order)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end

        context 'where another order shares the same representation' do
          before do
            established_mir.add_to_order(FactoryBot.create(:order))
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = established_mir.self_and_ancestors.count

            expect {
              established_mir.add_to_order(order)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end
      end
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
