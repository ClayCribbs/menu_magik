FactoryBot.define do
  factory(:menu) do
      title           { Faker::Food.ethnic_category }
      restaurant_name { Faker::Restaurant.name }
      status          { 0 }
  end
end
