def populate_menu_data(dry_run: true, items_identifier: ['menu_items', 'dishes'])
  errors = []
  successes = []

  ActiveRecord::Base.transaction do
    file_path = "#{Rails.root}/app/scripts/populate_menu/restaurant_data.json"
    menu_data = JSON.parse(File.read(file_path))
    restaurants = menu_data['restaurants']
    puts "#{restaurants.count} restaurants found"
    if restaurants.nil?
      return nil
      puts "No restaurants found"
    end

    restaurants.each do |restaurant|
      begin
        print "restaurant #{restaurant['name']} - running population... "
        new_restaurant = create_restaurant(restaurant['name'])
        puts "Creating menus for #{restaurant['name']}"
        restaurant['menus'].each do |menu|
          new_menu = create_menu(menu['name'], new_restaurant.id)
          items_identifier.map do |item_identifier|
            unless menu[item_identifier].nil?
              puts "Creating menu_items for #{restaurant['name']}"
              menu[item_identifier].each do |item|
                menu_item = create_menu_item(item['name'])
                create_menu_item_price(new_menu, menu_item, item['price'])
              end
            end
          end
        end
        puts "done."
        puts "Adding new restaurant id to successes array"
        successes << new_restaurant.id

      rescue Exception => exception
        puts exception.message
        puts exception.backtrace.inspect
        puts "Adding restaurant name to errors array"
        errors << [restaurant['name'], exception]
      end
    end

    if dry_run
      puts "Dry run complete, rolling back."
      raise ActiveRecord::Rollback
    elsif errors.any?
      puts "There were errors, rolling back."
      raise ActiveRecord::Rollback
    else
      puts "Committing data changes!"
    end
  end

  [errors, successes]

end

def create_restaurant(name)
  new_restaurant = Restaurant.create(name: name)
  return unless new_restaurant.persisted?
  puts "new Restaurant #{name} with id #{new_restaurant.id} was created"
  new_restaurant
end

def create_menu(name, restaurant_id)
  new_menu = Menu.create(name: name, restaurant_id: restaurant_id)
  return unless new_menu.persisted?
  puts "new Menu #{name} with id #{new_menu.id} was created"
  new_menu
end

def create_menu_item(name)
  menu_item = MenuItem.find_by_name(name)
  unless menu_item.nil?
    puts puts "MenuItem #{name} already exist with id #{menu_item.id}"
    return menu_item
  end
  menu_item = MenuItem.create(name: name)
  puts "new MenuItem #{name} with id #{menu_item.id} was created"
  menu_item
end

def create_menu_item_price(menu, menu_item, price)
  menu_item_price = MenuItemPrice.create(menu: menu, menu_item: menu_item, price: price)
  return unless menu_item_price.persisted?
  puts "new MenuItemPrice was created with id #{menu_item_price.id}"
end
