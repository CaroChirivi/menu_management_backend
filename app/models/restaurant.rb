# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :menu, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
