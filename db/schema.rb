# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_419_165_556) do
  create_table 'menu_items', force: :cascade do |t|
    t.integer 'menu_id'
    t.string 'name', limit: 100, null: false
    t.string 'description', limit: 500, null: false
    t.decimal 'price', precision: 4, scale: 2, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['menu_id'], name: 'index_menu_items_on_menu_id'
  end

  create_table 'menus', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'restaurant_id', null: false
    t.index %w[restaurant_id name], name: 'index_menus_on_restaurant_id_and_name', unique: true
  end

  create_table 'restaurants', force: :cascade do |t|
    t.string 'name', limit: 100, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_restaurants_on_name', unique: true
  end

  add_foreign_key 'menu_items', 'menus'
  add_foreign_key 'menus', 'restaurants'
end
