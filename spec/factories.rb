FactoryBot.define do
  factory(:menu) do
    title           { Faker::Food.ethnic_category }
    restaurant_name { Faker::Restaurant.name }
    status          { 0 }
  end

  factory(:menu_item) do
    menu        { create(:menu) }
    title       { Faker::Food.dish }
    price       { Faker::Commerce.price }
    description { Faker::Food.description }
    status      { 0 }
  end

  factory(:restaurant) do
    name           { Faker::Restaurant.name }
    street_address { Faker::Address.street_address }
    city           { Faker::Address.city }
    region         { Faker::Address.state }
    country        { Faker::Address.country }
    postal_code    { Faker::Address.zip_code }
    phone_number   { Faker::PhoneNumber.phone_number }
    status         { 0 }
  end
end
