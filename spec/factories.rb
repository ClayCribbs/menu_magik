FactoryBot.define do
  factory(:menu) do
    restaurant { create(:restaurant) }
    status     { 0 }
    title      { Faker::Food.ethnic_category }

    trait :with_menu_items do
      transient do
        ## This can be passed to factory bot as a param to make as many items as you would like
        number_of_menu_items { 1 }
      end

      after(:create) do |menu, options|
        options.number_of_menu_items.times do
          FactoryBot.create(:menu_assignment, menu: menu)
        end
      end
    end
  end

  factory(:menu_assignment) do
    menu      { create(:menu) }
    menu_item { create(:menu_item) }
  end

  factory(:menu_item) do
    restaurant  { create(:restaurant) }
    description { Faker::Food.description }
    price       { Faker::Commerce.price }
    status      { 0 }
    title       { Faker::Food.dish }

    trait :with_menus do
      transient do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus { 1 }
      end

      after(:create) do |menu_item, options|
        options.number_of_menus.times do
          menu_item.menus << FactoryBot.create(:menu_assignment, menu_item: menu_item)
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

    trait :with_empty_menus do
      transient do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus { 1 }
      end

      after(:create) do |restaurant|
        restaurant.menus << FactoryBot.create(:menu, restaurant: restaurant)
      end
    end

    trait :with_populated_menus do
      transient do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus { 1 }
      end

     after(:create) do |restaurant|
        restaurant.menus << FactoryBot.create(:menu, :with_menu_items, restaurant: restaurant)
      end
    end
  end

  factory(:menu_item_variation) do
    child_item       { create(:menu_item) }
    parent_item      { create(:menu_item) }
    price_adjustment { 0 }
  end
end
