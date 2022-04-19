# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :menu do
    name { Faker::Lorem.unique.word }
    restaurant { create(:restaurant) }
  end
end
