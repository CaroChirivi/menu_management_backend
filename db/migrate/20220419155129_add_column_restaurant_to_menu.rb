# frozen_string_literal: true

class AddColumnRestaurantToMenu < ActiveRecord::Migration[6.1]
  def change
    add_column :menus, :restaurant_id, :integer
  end
end
