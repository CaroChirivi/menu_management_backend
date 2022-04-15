class CreateMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items do |t|
      t.belongs_to :menu, foreign_key: true, index: true
      t.string  :name, null: false, limit: 100
      t.string  :description, null: false, limit: 500
      t.decimal :price, null:false, precision: 4, scale: 2

      t.timestamps
    end
  end
end
