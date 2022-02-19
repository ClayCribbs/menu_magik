FactoryBot.define do
  factory(:menu) do
    restaurant      { create(:restaurant) }
    restaurant_name { Faker::Restaurant.name }
    status          { 0 }
    title           { Faker::Food.ethnic_category }
  end

  factory(:menu_item) do
    menu        { create(:menu) }
    description { Faker::Food.description }
    price       { Faker::Commerce.price }
    status      { 0 }
    title       { Faker::Food.dish }
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
  end
end
