# frozen_string_literal: true

class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
