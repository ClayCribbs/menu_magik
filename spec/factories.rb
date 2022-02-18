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
end
