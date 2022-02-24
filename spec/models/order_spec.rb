require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :status,
                                                :user_id
                                              ]
  end

  context 'associations' do
    [  #model        #association
      [:menu_items,  :has_many],
      [:user,        :belongs_to],
    ].each do |model, association|
      include_examples 'associates_with', model, association
    end
  end

  describe '#add_item_to_order' do
    let(:order) { FactoryBot.create(:order) }
    let(:representation) { FactoryBot.create(:menu_item_representation) }

    context 'it'
      it 'fails' do
        expect {
          order.create_order_items_from_menu_item_representation(nil)
        }.to raise_error(NoMethodError)
      end
    end

    context 'with a valid menu_item_representation' do
      context 'with no children or parents' do
        it 'creates an associated order_item' do
          expect(representation.parent).to eq(nil)
          expect(representation.children).to be_empty
          expect {
            order.create_order_items_from_menu_item_representation(representation)
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
              expect(order.menu_item_representations).to include(established_representation)
              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item for each ancestor that has none' do
              expected_count = established_representation.self_and_ancestors.count

              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
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

            it 'does not create an order_item' do
              expect(order.menu_item_representations).to include(established_representation)
              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item for each ancestor that has none' do
              existing_order_items = order.order_items
                                      .pluck(:menu_item_representation_id)
              expected_count       = established_representation.self_and_ancestors
                                      .where('id NOT IN (?)', existing_order_items)
                                      .count

              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
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
              expect(order.menu_item_representations).to include(established_representation)
              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
              }.to change { OrderItem.count }.by(0)
            end
          end

          context 'where no children share the order' do
            it 'creates an associated order_item' do
              expect(representation.parent).to eq(nil)
              expect(representation.children).to be_empty
              expect {
                order.create_order_items_from_menu_item_representation(established_representation)
              }.to change { OrderItem.count }.by(1)
            end
          end
        end

        context 'where a granduncle shares the order' do
          before do
            granduncle.add_to_order(order)
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = (established_representation.self_and_ancestors - granduncle.self_and_ancestors).count

            expect {
              order.create_order_items_from_menu_item_representation(established_representation)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end

        context 'where a nephew shares the order' do
          before do
            nephew.add_to_order(order)
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = (established_representation.self_and_ancestors - nephew.self_and_ancestors).count

            expect {
              order.create_order_items_from_menu_item_representation(established_representation)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end

        context 'where another order shares the same representation' do
          before do
            FactoryBot.create(:order).create_order_items_from_menu_item_representation(established_representation)
          end

          it 'creates an associated order_item for each ancestor that has none' do
            expected_count = established_representation.self_and_ancestors.count

            expect {
              order.create_order_items_from_menu_item_representation(established_representation)
            }.to change { OrderItem.count }.by(expected_count)
          end
        end
      end
    end
  end
end
