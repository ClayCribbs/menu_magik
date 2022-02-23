require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :price,
                                                :restaurant_id,
                                                :status,
                                                :title,
                                              ]

    context 'associations' do
      [  #model       #association
        [:restaurant, :belongs_to],
        [:menus,      :has_many],
      ].each do |model, association|
        include_examples 'associates_with', model, association
      end
    end

    context 'uniqueness' do
      context '#title' do
        context 'with a menu_item that does not share the same title' do
          let(:existing_menu_item) { FactoryBot.create(:menu_item, title: 'Example') }

          context 'that shares the same restaurant' do
            let(:menu_item) {
              build(:menu_item,
                     title: 'Not Example',
                     restaurant: existing_menu_item.restaurant)
            }

            it 'is not valid' do
              expect(menu_item).to be_valid
              expect(menu_item.errors).to be_empty
            end
          end

          context 'that does not share the same restaurant' do
            let(:menu_item) {
              build(:menu_item,
                     title: 'Not Example',
                     restaurant: FactoryBot.create(:restaurant))
            }

            it 'is valid' do
              expect(menu_item).to be_valid
              expect(menu_item.errors).to be_empty
            end
          end
        end

        context 'with a menu_item that shares the same title' do
          let(:existing_menu_item) { FactoryBot.create(:menu_item, title: 'Example') }

          context 'that shares the same restaurant' do
            let(:menu_item) {
              build(:menu_item,
                     title: 'Example',
                     restaurant: existing_menu_item.restaurant)
            }

            it 'is not valid' do
              expect(menu_item).not_to be_valid
              expect(menu_item.errors).to have_key(:title)
            end
          end

          context 'that does not share the same restaurant' do
            let(:menu_item) {
              build(:menu_item,
                     title: 'Example',
                     restaurant: FactoryBot.create(:restaurant))
            }

            it 'is valid' do
              expect(menu_item).to be_valid
              expect(menu_item.errors).to be_empty
            end
          end
        end
      end
    end
  end

  describe '#menus' do
    let!(:menu)                     { FactoryBot.create(:menu) }
    let!(:menu_item)                { FactoryBot.create(:menu_item) }
    let!(:menu_item_representation) {
      FactoryBot.create(:menu_item_representation,
                         menu: menu,
                         menu_item: menu_item)
    }

    context 'when associating with a menu' do
      let!(:menu2) { FactoryBot.create(:menu) }

      it 'persists its association to the original menu' do
        expect {
          menu2.menu_items << menu_item
          menu2.save!
        }.to change { menu.menu_items.count }.by(0)
        expect(menu.menu_items.pluck(:id)).to include(menu_item.id)
        expect(menu_item.menus.pluck(:id)).to include(menu.id)
      end

      it 'associates correctly' do
        expect {
          menu2.menu_items << menu_item
          menu2.save!
        }.to change { menu_item.menus.count }.by(1)
        expect(menu2.menu_items.pluck(:id)).to include(menu_item.id)
        expect(menu_item.menus.pluck(:id)).to include(menu2.id)
      end
    end

    context 'when removing an association to a menu' do
      let!(:menu2) { FactoryBot.create(:menu) }
      let!(:menu_item_representation2) {
        FactoryBot.create(:menu_item_representation,
                           menu: menu2,
                           menu_item: menu_item)
      }

      it 'persists its association to the original menu' do
        expect {
          menu2.menu_items.delete(menu_item)
          menu2.save!
        }.to change { menu.menu_items.count }.by(0)
        expect(menu.menu_items.pluck(:id)).to include(menu_item.id)
        expect(menu_item.menus.pluck(:id)).to include(menu.id)
      end

      it 'removes the association correctly' do
        expect {
          menu2.menu_items.delete(menu_item)
          menu2.save!
        }.to change { menu_item.menus.count }.by(-1)
        expect(menu2.menu_items.pluck(:id)).not_to include(menu_item.id)
        expect(menu_item.menus.pluck(:id)).not_to include(menu2.id)
      end
    end
  end
end
