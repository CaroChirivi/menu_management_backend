def populate_menu_data(dry_run: true)
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
        new_restaurant = Restaurant.create(name: restaurant['name'])
        puts "new Restaurant #{restaurant['name']} was created"
        puts "Creating menus for #{restaurant['name']}"
        restaurant['menus'].each do |menu|
          new_menu = Menu.create(name: menu['name'], restaurant_id: new_restaurant.id)
          puts "new Menu #{menu['name']} was created in Restaurant #{restaurant['name']}"
          %w[menu_items dishes].map do |items_identifier|
            unless menu[items_identifier].nil?
              puts "Creating menu_items for #{restaurant['name']}"
              menu[items_identifier].each do |item|
                item['menu_id'] = new_menu.id
                MenuItem.create(item)
                puts "new MenuItem #{item['name']} was created in Menu #{menu['name']} For Restaurant #{restaurant['name']}"
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
