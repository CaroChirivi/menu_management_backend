class RemoveNotNullDescriptionFromMenuItems < ActiveRecord::Migration[6.1]
  def change
    change_column_null :menu_items, :description, true
  end
end
