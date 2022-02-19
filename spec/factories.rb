FactoryBot.define do
  factory(:menu) do
    restaurant      { create(:restaurant) }
    status          { 0 }
    title           { Faker::Food.ethnic_category }

    trait :with_menu_items do
      defaults do
        ## This can be passed to factory bot as a param to make as many items as you would like
        number_of_menu_items = 1
      end

      after(:build) do |menu, evaluator|
        evaluator.number_of_menu_items.times do
          menu.menu_items << FactoryGirl.create(:menu_item)
        end
      end
    end
  end

  factory(:menu_assignment) do
    menu { create(:menu) }
    menu_item { create(:menu_item) }
  end

  factory(:menu_item) do
    description { Faker::Food.description }
    price       { Faker::Commerce.price }
    status      { 0 }
    title       { Faker::Food.dish }

    trait :with_menus do
      defaults do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus = 1
      end

      after(:build) do |menu_item, evaluator|
        evaluator.number_of_menus.times do
          menu_item.menus << FactoryGirl.create(:menu)
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
      defaults do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus = 1
      end

      after(:build) do |restaurant|
        restaurant.menus << FactoryGirl.create(:menu)
      end
    end

    trait :with_populated_menus do
      defaults do
        ## This can be passed to factory bot as a param to make as many menus as you would like
        number_of_menus = 1
      end

     after(:build) do |restaurant|
        restaurant.menus << FactoryGirl.create(:men, :with_menu_items)
      end
    end
  end
end
