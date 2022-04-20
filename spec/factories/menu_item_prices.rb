# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item_price do
    menu { nil }
    menu_item { nil }
    price { 1 }
  end
end
