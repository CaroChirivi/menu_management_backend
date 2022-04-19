# frozen_string_literal: true

class AddForeignKeyRestaurantToMenu < ActiveRecord::Migration[6.1]
  def change
    change_column_null :menus, :restaurant_id, false
    add_foreign_key :menus, :restaurants
    add_index :menus, %i[restaurant_id name], unique: true
  end
end
