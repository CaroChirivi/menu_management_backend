# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :menu_item do
    name  { Faker::Food.unique.dish }
  end
end
