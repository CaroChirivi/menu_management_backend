# frozen_string_literal: true

class CreateMenuItemPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_item_prices do |t|
      t.references :menu, null: false, foreign_key: true, index: true
      t.references :menu_item, null: false, foreign_key: true, index: true
      t.decimal :price, null: false, precision: 4, scale: 2
      t.string  :description, null: true, limit: 500

      t.timestamps
    end
  end
end
