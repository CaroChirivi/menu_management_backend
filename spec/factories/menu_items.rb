# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :menu_item do
    menu        { create(:menu) }
    name        { Faker::Food.dish }
    description { Faker::Food.description }
    price       { Faker::Commerce.price }

    trait :no_valid do
      menu        { nil }
      name        { nil }
      description { nil }
      price       { nil }
    end
  end
end
