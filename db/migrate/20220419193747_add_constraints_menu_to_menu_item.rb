class AddConstraintsMenuToMenuItem < ActiveRecord::Migration[6.1]
  def change
    change_column_null :menu_items, :menu_id, false
    remove_index :menu_items, name: 'index_menu_items_on_menu_id'
    add_index :menu_items, %i[menu_id name], unique: true
  end
end
