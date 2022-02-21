require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :price,
                                                :restaurant_id,
                                                :status,
                                                :title,
                                              ]

    context 'with existing menu_item that has the same title' do
      let(:existing_menu_item) { FactoryBot.create(:menu_item, title: 'Example') }

      context 'that shares the same restaurant' do
        it 'is not valid' do
          menu_item = build(:menu_item,
                             title: 'Example',
                             restaurant: existing_menu_item.restaurant)

          expect(menu_item).not_to be_valid
          expect(menu_item.errors).to have_key(:title)
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

  describe '#restaurant' do
    it 'belongs to restaurant' do
      association_to_restaurant = MenuItem.reflect_on_association(:restaurant)
      expect(association_to_restaurant.macro).to eq(:belongs_to)
    end
  end

  describe '#parents' do
    let!(:menu_item_parent1) { FactoryBot.create(:menu_item) }
    let!(:menu_item_parent2) { FactoryBot.create(:menu_item) }
    let!(:menu_item_child)   { FactoryBot.create(:menu_item) }

    it 'has_many parents' do
      association_to_parents = MenuItem.reflect_on_association(:parents)
      expect(association_to_parents.macro).to eq(:has_many)
    end

    context 'with one associated parent' do
      before do
        menu_item_parent1.children << menu_item_child
        menu_item_parent1.save!
      end

      context 'when associating with a new parent' do
        it 'persists its assocation to the original parent' do
          expect(menu_item_child.parents.count).to eq(1)
          expect(menu_item_child.parents).to include(menu_item_parent1)

          menu_item_parent2.children << menu_item_child
          menu_item_parent2.save!

          expect(menu_item_child.parents.count).to eq(2)
          expect(menu_item_child.parents).to include(menu_item_parent1)
          expect(menu_item_child.parents).to include(menu_item_parent2)
        end
      end
    end

    context 'with multiple associated parents' do
      before do
        menu_item_parent1.children << menu_item_child
        menu_item_parent2.children << menu_item_child
        menu_item_parent1.save!
        menu_item_parent2.save!
      end

      context 'when removing a parent' do
        it 'persists its associations with other parents' do
          expect(menu_item_child.parents.count).to eq(2)
          expect(menu_item_child.parents).to include(menu_item_parent1)
          expect(menu_item_child.parents).to include(menu_item_parent2)

          menu_item_parent1.children.delete(menu_item_child)
          menu_item_parent1.save!

          expect(menu_item_child.parents.count).to eq(1)
          expect(menu_item_child.parents).to include(menu_item_parent2)
          expect(menu_item_child.parents).not_to include(menu_item_parent1)
        end
      end
    end
  end

  describe '#menus' do
    it 'has_many menus' do
      association_to_menus = MenuItem.reflect_on_association(:menus)
      expect(association_to_menus.macro).to eq(:has_many)
    end

    context 'with one associated menu' do
      let(:menu1)       { FactoryBot.create(:menu, :with_menu_items, number_of_menu_items: 3) }
      let(:menu2)       { FactoryBot.create(:menu, restaurant: menu_item1.restaurant) }
      let!(:menu_item1) { menu1.menu_items.first }

      context 'when associating with a new menu' do
        it 'persists its association to the original menu' do
          expect(menu_item1.menus.count).to eq(1)

          menu2.menu_items << menu_item1

          expect(menu_item1.menus.count).to eq(2)
          expect(menu1.menu_items).to include(menu_item1)
          expect(menu2.menu_items).to include(menu_item1)
        end
      end
    end

    context 'with multiple associated menus' do
      let(:menu1)       { FactoryBot.create(:menu, :with_menu_items, number_of_menu_items: 3) }
      let(:menu2)       { FactoryBot.create(:menu, restaurant: menu_item1.restaurant) }
      let!(:menu_item1) { menu1.menu_items.first }

      before do
        menu2.menu_items << menu_item1
      end

      context 'when removing a menu' do
        it 'persists its associations with other menus' do
          expect(menu_item1.menus.count).to eq(2)

          menu2.menu_items.delete(menu_item1)

          expect(menu_item1.menus.count).to eq(1)
          expect(menu1.menu_items).to include(menu_item1)
          expect(menu2.menu_items).not_to include(menu_item1)
        end
      end
    end
  end

  describe '#create_child' do
    let!(:menu_item_parent) { FactoryBot.create(:menu_item) }

    it 'increases children.count by 1' do
      expect {
        menu_item_parent.create_child(title: 'Side Portion')
      }.to change { menu_item_parent.children.count }.by(1)
    end

    it 'creates a new menu_item' do
      expect {
        menu_item_parent.create_child(title: 'Side Portion')
      }.to change { MenuItem.count }.by(1)
    end

    it 'creates a new menu_item variation' do
      expect {
        menu_item_parent.create_child(title: 'Side Portion')
      }.to change { MenuItemVariation.count }.by(1)
    end
  end
end
