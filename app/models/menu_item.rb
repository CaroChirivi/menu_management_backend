# frozen_string_literal: true

class MenuItem < ApplicationRecord
  has_many :menu_item_price, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
