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

  factory(:representation) do
    presenter   { create(:menu) }
    presentable { create(:menu_item) }
  end

  factory(:menu_item_representation) do
    menu      { create(:menu) }
    menu_item { create(:menu_item) }

    trait :in_a_populated_tree do
      after(:build) do |rep|
        greatgrandparent = create(:representation,
                                   menu: menu)
        grandparent      = create(:representation,
                                   menu: menu,
                                   parent: great_grandparent)
        granduncle       = create(:representation,
                                   menu: menu,
                                   parent: great_grandparent)
        rep.parent       = create(:representation,
                                   menu: menu,
                                   parent: grandparent)
        uncle            = create(:representation,
                                   menu: menu,
                                   parent: grandparent)
        sibling          = create(:representation,
                                   menu: menu,
                                   parent: parent)
        child            = create(:representation,
                                   menu: menu,
                                   parent: rep)
        nephew           = create(:representation,
                                   menu: menu,
                                   parent: sibling)
        grandchild       = create(:representation,
                                   menu: menu,
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
        2.times do
          order.order_items << FactoryBot.create(:menu_item,
                                                  restaurant: menu.restaurant)
        end
      end
    end
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
