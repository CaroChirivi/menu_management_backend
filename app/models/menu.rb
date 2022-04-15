# frozen_string_literal: true

class Menu < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
