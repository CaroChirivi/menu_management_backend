# frozen_string_literal: true

class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 10_000 }
end
