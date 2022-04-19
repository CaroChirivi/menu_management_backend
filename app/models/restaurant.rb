# frozen_string_literal: true

class Restaurant < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true
end
