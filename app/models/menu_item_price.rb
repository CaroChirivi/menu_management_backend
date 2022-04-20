# frozen_string_literal: true

class MenuItemPrice < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :description, length: { maximum: 500 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 10_000 }
end
