require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    let(:restaurant) { FactoryBot.create(:restaurant) }

    it 'is a valid class' do
      expect(restaurant.class.name).to eq('Restaurant')
    end

    it 'persists when saved to the database' do
      expect {
        restaurant.save!
      }.to change { Restaurant.count }.by(1)
      expect(Restaurant.find(restaurant.id)).to eq(restaurant)
    end

    it 'has relevant attributes' do
      expected_attribute_keys = [
       'city',
       'country',
       'name',
       'phone_number',
       'postal_code',
       'region',
       'status',
       'street_address',
      ].each do |attribute|
        expect(restaurant.attributes.keys).to include(attribute)
      end
    end

    context '#menus' do
      let!(:menu1) { FactoryBot.create(:menu, restaurant: restaurant) }
      let!(:menu2) { FactoryBot.create(:menu, restaurant: restaurant) }

      let!(:restaurant_control) { FactoryBot.build(:restaurant) }
      let!(:menu_control)       { FactoryBot.build(:menu, restaurant: restaurant_control) }

      it 'has many menus' do
        expect(restaurant.menus.count).to eq(2)
      end

      context 'when creating an associated menu' do
        let!(:new_menu) { FactoryBot.build(:menu, restaurant: restaurant) }

        it 'increases menus count by 1' do
          expect {
            new_menu.save!
          }.to change { restaurant.menus.count }.by(1)
        end

        it 'does not increase other restaurant menus count' do
          expect {
            new_menu.save!
          }.to change { restaurant_control.menus.count }.by(0)
        end
      end

      context 'when removing an associated menu' do
        let!(:new_menu) { FactoryBot.create(:menu, restaurant: restaurant) }

        it 'decreases menus count by 1' do
          expect {
            new_menu.destroy
            restaurant.menus.delete(new_menu)
          }.to change { restaurant.menus.count }.by(-1)
        end

        it 'does not decrease other restaurant menus count' do
          expect {
            restaurant.menus.delete(new_menu)
          }.to change { restaurant_control.menus.count }.by(0)
        end
      end
    end

    context 'with associated menu_items' do
      let!(:menu_item)  { FactoryBot.create(:menu_item, restaurant: restaurant) }
      let!(:menu_item2) { FactoryBot.create(:menu_item, restaurant: restaurant) }

      let!(:restaurant_control) { FactoryBot.build(:restaurant) }
      let!(:menu_item_control)  { FactoryBot.build(:menu_item, restaurant: restaurant_control) }

      it 'has many menu_items' do
        expect(restaurant.menu_items.count).to eq(2)
      end

      context 'when creating an associated menu_item' do
        let!(:new_menu_item) { FactoryBot.build(:menu_item, restaurant: restaurant) }

        it 'increases menu_items count by 1' do
          expect {
            new_menu_item.save!
          }.to change { restaurant.menu_items.count }.by(1)
        end

        it 'does not increase other restaurant menu_items count' do
          expect {
            new_menu_item.save!
          }.to change { restaurant_control.menu_items.count }.by(0)
        end
      end

      context 'when removing an associated menu_item' do
        let!(:new_menu_item) { FactoryBot.create(:menu_item, restaurant: restaurant) }

        it 'decreases menu_items count by 1' do
          expect {
            restaurant.menu_items.delete(new_menu_item)
          }.to change { restaurant.menu_items.count }.by(-1)
        end

        it 'does not decrease other restaurant menu_items count' do
          expect {
            restaurant.menu_items.delete(new_menu_item)
          }.to change { restaurant_control.menu_items.count }.by(0)
        end
      end
    end
  end
end

RSpec.describe Menu, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    let!(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:menu)       { FactoryBot.build(:menu, restaurant: restaurant) }

    it 'is a valid class' do
      expect(menu.class.name).to eq('Menu')
    end

    it 'persists when saved to the database' do
      expect {
        menu.save!
      }.to change { Menu.count }.by(1)
      expect(Menu.find(menu.id)).to eq(menu)
    end

    it 'has relevant attributes' do
      expected_attribute_keys = [
        'status',
        'title',
      ].each do |attribute|
        expect(menu.attributes.keys).to include(attribute)
      end
    end

    context '#menu_items' do
      let!(:menu_item)         { FactoryBot.create(:menu_item, restaurant: restaurant) }
      let!(:menu_item2)        { FactoryBot.create(:menu_item, restaurant: restaurant) }

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
end

RSpec.describe MenuItem, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    let!(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:menu_item)  { FactoryBot.build(:menu_item, restaurant: restaurant) }

    it 'is a valid class' do
      expect(menu_item.class.name).to eq('MenuItem')
    end

    it 'persists when saved to the database' do
      expect {
        menu_item.save!
      }.to change { MenuItem.count }.by(1)
      expect(MenuItem.find(menu_item.id)).to eq(menu_item)
    end

    it 'has relevant attributes' do
      expected_attribute_keys = [
        'description',
        'price',
        'status',
        'title',
      ].each do |attribute|
        expect(menu_item.attributes.keys).to include(attribute)
      end
    end

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

RSpec.describe User, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    let(:user) { FactoryBot.create(:user) }

    it 'is a valid class' do
      expect(user.class.name).to eq('User')
    end

    it 'persists when saved to the database' do
      expect {
        user.save!
      }.to change { User.count }.by(1)
      expect(User.find(user.id)).to eq(user)
    end

    it 'has relevant attributes' do
      expected_attribute_keys = [
        'city',
        'country',
        'name',
        'phone_number',
        'postal_code',
        'region',
        'status',
        'street_address',
      ].each do |attribute|
        expect(user.attributes.keys).to include(attribute)
      end
    end

    context '#orders' do
      let!(:order1) { FactoryBot.create(:order, user: user) }
      let!(:order2) { FactoryBot.create(:order, user: user) }

      let!(:user_control) { FactoryBot.build(:user) }
      let!(:order_control){ FactoryBot.build(:order, user: user_control) }

      it 'has many orders' do
        expect(user.orders.count).to eq(2)
      end

      context 'when creating an associated order' do
        let!(:new_order) { FactoryBot.build(:order, user: user) }

        it 'increases orders count by 1' do
          expect {
            new_order.save!
          }.to change { user.orders.count }.by(1)
        end

        it 'does not increase other user orders count' do
          expect {
            new_order.save!
          }.to change { user_control.orders.count }.by(0)
        end
      end

      context 'when removing an associated order' do
        let!(:new_order) { FactoryBot.create(:order, user: user) }

        it 'decreases orders count by 1' do
          expect {
            new_order.destroy
            user.orders.delete(new_order)
          }.to change { user.orders.count }.by(-1)
        end

        it 'does not decrease other user orders count' do
          expect {
            user.orders.delete(new_order)
          }.to change { user_control.orders.count }.by(0)
        end
      end
    end
  end
end

RSpec.describe Order, type: :model do
  context 'when ensuring it passes the Popmenu challenge' do
    let(:order) { FactoryBot.create(:order) }

    it 'is a valid class' do
      expect(order.class.name).to eq('Order')
    end

    it 'persists when saved to the database' do
      expect {
        order.save!
      }.to change { Order.count }.by(1)
      expect(Order.find(order.id)).to eq(order)
    end

    it 'has relevant attributes' do
      expected_attribute_keys = [
        'user_id',
        'restaurant_id',
      ].each do |attribute|
        expect(order.attributes.keys).to include(attribute)
      end
    end

    context 'when creating an order for a dinner salad' do
      let(:user)             { FactoryBot.create(:user) }
      let(:salad)            { FactoryBot.create(:menu_item, title: 'Salad') }
      let(:ceasar_dressing)  { FactoryBot.create(:menu_item, title: 'Ceasar Dressing') }
      let(:ranch_dressing)   { FactoryBot.create(:menu_item, title: 'Ranch Dressing') }
      let(:italian_dressing) { FactoryBot.create(:menu_item, title: 'Italian Dressing') }
      let(:roast_beef)       { FactoryBot.create(:menu_item, title: 'Roast Beef') }

      let(:dinner_menu) { FactoryBot.create(:menu, title: 'Dinner Menu') }
      let(:mir)         { MenuItemRepresentation.create(menu: dinner_menu, menu_item: salad) }
      let(:mir2)        { MenuItemRepresentation.create(menu: dinner_menu, menu_item: roast_beef) }
      let!(:new_order)   { FactoryBot.create(:order, user: user) }

      before do
        mir.create_child_from_menu_item(ceasar_dressing)
        mir.create_child_from_menu_item(ranch_dressing)
        mir.create_child_from_menu_item(italian_dressing)
        mir.copy_self_and_descendents_to(mir2)
      end

      context 'as a standalone dish' do
        it 'can be ordered' do
          expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(salad.id)

          expect {
            new_order.create_order_items_from_menu_item_representation(mir)
          }.to change { new_order.order_items.count }.by(1)

          expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(salad.id)
        end

        context 'with a selection of dressing' do
          it 'can be ordered' do
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(salad.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(ceasar_dressing.id)

            expect {
              new_order.create_order_items_from_menu_item_representation(mir)
              new_order.create_order_items_from_menu_item_representation(mir.children.first)
            }.to change { new_order.order_items.count }.by(2)

            expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(salad.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(ceasar_dressing.id)
          end
        end
      end

      context 'as a side of another item' do
        it 'can be ordered' do
          expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(salad.id)

          expect {
            new_order.create_order_items_from_menu_item_representation(mir2.children.first)
          }.to change { new_order.order_items.count }.by(2)

          expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(salad.id)
        end

        context 'with a selection of dressing' do
          it 'can be ordered' do
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(roast_beef.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(salad.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).not_to include(ceasar_dressing.id)

            expect {
              new_order.create_order_items_from_menu_item_representation(mir2.children.first.children.first)
            }.to change { new_order.order_items.count }.by(3)

            expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(roast_beef.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(salad.id)
            expect(new_order.menu_item_representations.pluck(:menu_item_id)).to include(ceasar_dressing.id)
          end
        end
      end
    end
  end
end
