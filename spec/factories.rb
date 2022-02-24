FactoryBot.define do
  factory(:menu) do
    restaurant { create(:restaurant) }
    status     { 0 }
    title      { Faker::Food.ethnic_category }

    trait :with_menu_items do
      after(:create) do |menu, options|
        2.times do
          menu.menu_items << FactoryBot.create(:menu_item,
                                                restaurant: menu.restaurant)
        end
      end
    end
  end

  factory(:menu_item) do
    restaurant  { create(:restaurant) }
    description { Faker::Food.description }
    price       { Faker::Number.between(from: 0.0, to: 30.0).round(2) }
    status      { 0 }
    title       { Faker::Food.dish }

    trait :with_menu do
      after(:create) do |menu_item, options|
        menu_item.menus << FactoryBot.create(:menu, restaurant: menu_item.restaurant)
      end
    end
  end

  factory(:menu_item_representation) do
    menu             { create(:menu) }
    menu_item        { create(:menu_item) }

    trait :in_a_populated_tree do
      after(:build) do |mir|
        greatgrandparent = create(:menu_item_representation,
                                   menu: mir.menu)
        grandparent      = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: great_grandparent)
        granduncle       = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: great_grandparent)
        mir.parent       = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: grandparent)
        uncle            = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: grandparent)
        sibling          = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: parent)
        child            = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: mir)
        nephew           = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: sibling)
        grandchild       = create(:menu_item_representation,
                                   menu: mir.menu,
                                   parent: child)
      end
    end
  end

  factory(:order) do
    user       { create(:user) }
    restaurant { create(:restaurant) }
    status     { 0 }

    trait :with_order_items do
      after(:create) do |order, options|
        order.order_items << FactoryBot.create(:order_item,
                                                restaurant: order.restaurant)
      end
    end
  end

  factory(:order_item) do
    order                    { create(:order) }
    menu_item_representation { create(:menu_item_representation) }
  end

  factory(:restaurant) do
    city           { Faker::Address.city }
    country        { Faker::Address.country }
    name           { Faker::Restaurant.name }
    phone_number   { Faker::PhoneNumber.phone_number }
    postal_code    { Faker::Address.zip_code }
    region         { Faker::Address.state }
    status         { 0 }
    street_address { Faker::Address.street_address }

    trait :with_populated_menus do
      after(:create) do |restaurant|
        restaurant.menus << FactoryBot.create(:menu, :with_menu_items)
      end
    end
  end

  factory(:user) do
    city           { Faker::Address.city }
    country        { Faker::Address.country }
    name           { Faker::Name.name }
    phone_number   { Faker::PhoneNumber.phone_number }
    postal_code    { Faker::Address.zip_code }
    region         { Faker::Address.state }
    status         { 0 }
    street_address { Faker::Address.street_address }

    trait :with_orders do
      after(:create) do |user, options|
        user.orders << FactoryBot.create(:order,
                                          user: user,
                                          restaurant: order.restaurant)
      end
    end
  end
end
