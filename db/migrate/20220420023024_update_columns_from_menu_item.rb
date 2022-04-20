# frozen_string_literal: true

class UpdateColumnsFromMenuItem < ActiveRecord::Migration[6.1]
  def change
    remove_reference :menu_items, :menu, index: true, foreign_key: true
    change_column_null :menu_items, :description, true
    remove_column :menu_items, :price, :decimal
    remove_column :menu_items, :description, :string

    remove_index :menu_items, name: 'index_menu_items_on_index_menu_items_on_menu_id'
    add_index :menu_items, :name, unique: true
  end
end
