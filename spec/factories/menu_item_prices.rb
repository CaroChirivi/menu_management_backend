# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item_price do
    menu        { create(:menu) }
    menu_item   { create(:menu_item) }
    price       { Faker::Commerce.price }
    description { Faker::Food.description }
  end
end
