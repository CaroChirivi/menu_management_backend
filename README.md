# Requirements Menu Management Backend

The next levels of requirements are in individual branches, which try to show an iterative approach.
There are two approachs, in different branches path:
+ branches, _level_one_basics_ => _level_two_multiple_menus_ => _level_three_populate_system_. In this approach I understood
  **MenuItems** name not to be duplicate for each menu, so I develop the next steps with this
  requirement.
+ branches, _level_one_basics_ => _level_two_main_approach_ => _level_three_main_approach_ Thinking
  in the exact requirement I created a branch in the commit before I started the last approach
  and create a different one that follow in a better way the requirements.

##Installation
+ This is a Ruby on Rails project you have to check if can run a Ruby on Rails project in your
  local machine. Check the official site of RoR in order to run the application. _https://guides.rubyonrails.org/getting_started.html_

+ Clone the public repository _https://github.com/CaroChirivi/menu_management_backend.git_
+ Go to the directory where you clone the repository and run _bundle install_
+ The MDBS is the default configure with Ruby on Rails project (_sqlite3_) to generate tables on database
  run the migrations with the command _rake db:migrate_
+ For running the rails server run _rails s_
+ For running the rails console use _rails c_
+ For running all specs in the project directory run _bundle exec rspec --format doc_
+ For running specific spec run _bundle exec rspec --format doc path/to/file_
  Specs are located in _spec/models/_ directory.

## Level 1: Basics
### Requirements
+ Create an object model for **Menu** and **MenuItem** s classes.
+ **Menu** has many **MenuItem** s.
+ **Menu** and **MenuItem** have typical data associated with restaurants.
+ Illustrate behavior via unit tests.
### Developer notes
#### Initial configuration
Next gems was added:
+ _gem factory_bot_ for the creation of fixtures.
+ _gem rspec-rails_ for the creation of unit test.
+ _gem rubocop_ as a linter.
+ _gem faker_ for fake creation of data.

I chose them, because are libraries with I have worked, commonly used and simple to work with.

Models, migrations, factories and spec files were created using rails commands, like:
_rails generate Model Menu name:string_
_rails g migration AddColumnRestaurantToMenu_

#### Level approach
+ Model **Menu**: is configure with "validates" helper and the migration is defined in order to use some restrictions that
  allow us have consistent records in the DB. Here name is required, a string with length limit of 100 characters and unique.
  An association _has_many_ to **MenuItems** model.
+ Testing model **Menu**: configure factory spec/factories/memus.rb using FactoryBot and Faker.
  Creating specs for **Menu** model in spec/models/menu_spec.rb, I tried to test general CRUD behavior of it and association with **MenuItem**.
+ Model **MenuItem**: was created with name:string, description:string and price:decimal.
  It is set up with an association _belongs_to_ to **Menu** model.
  The migration has a _foreing_key_ to **menus** table to assure integrity of data.

## Level 2: Multiple Menus
### Requirements
+ Introduce a **Restaurant** model, and allow **Restaurant** s to have multiple **Menu** s.
+ **MenuItem** names should not be duplicated in the database.
+ **MenuItem** can be on multiple **Menu** s of a **Restaurant** .
+ Illustrate behavior via unit tests.

### Developer notes
#### Level approach
+ Model **Restaurant**: is configure with "validates" helper and the migration is defined in order to use some restrictions that
  allow us have consistent records in the DB. Here name is required, a string with length limit of 100 characters and unique.
  An association _has_many_ to **Menu** model.
+ **Restaurant** migration: configured with uniqueness constraint for _name_ column and an _index_ too.
+ An _Integer_ column _restaurant_id_ is created with a migration file, in order to allow this new association
  between **Restaurant** and **Menu**. If table _menus_ have records, a **backpopulation_task** on table
  _menus_ have to be done. Backpopulate the new column with not null and existing _restaurant_id_, which will depend of
  business logic, then, another migration must run.
  The new migration set up the new column as a _foreign_key_, _not null_ with an _index_.
+ Added associations between models **Menu** and **Restaurant** in model and migration files.
  **Restaurant** can have one or more **Menu** and a **Menu** belongs to a **Restaurant**.
  Modified uniqueness constraint in **Menu** model for only scope of Restaurant, which allow diferents restaurants have same name of menu, but unique for one restaurant.
+ Model **MenuItemPrice**: a new model an table were created in order to follow requirement "MenuItem names should not be duplicated in the database". In this new table we associate
  a _menu_ and _menu_item_ and a _price_. With this approach we leave the _menu_items_ table whit only a field _name_ (including
  timestamps for all tables) it will assure the uniqueness of the name.
+ **MenuItem** model is updated with the new approach and validate uniqueness of name. With a migration we remove
  columns not needed and add unique constraint and an index.
+ Testing **MenuItemPrice**: I updated _menus_ and _menu_items_ factories in order to follow the new approach and new associations.
  Factory and specs were created for new **MenuItemPrice** model. Testing CRUD and associations with **Menu** and **MenuItem**.

## Level 3: Populate menu system
### Requirements
+ Convert the following json body from the included file, **restaurant_data.json** in to
  our new menu system.
+ Make any model/validation changes that you feel are necessary to make the
  import as complete as possible.
+ The output should return a list of logs for each menu item and a success/fail
  result.
+ Apply what you consider to be adequate logging and exception handling.
+ Illustrate behavior via unit tests.

### Developer notes
#### Level approach
To populate the menu system I created a script which is in _app/scripts/populate_menu_ folder, here we can find the json file and the script.
The script follow these approach:
+ Have a main method for running the script. Method _populate_menu_data_ which receive two paramenters: _dry_run_ and _items_identifier_
    + _dry_run_ define is is a dry run(dry_run: true) or a real run(dry_run: false). The idea is only run a real one (dry_run: false) in production when everything
      was checked and tested. By default is set to _true_.
    + _items_identifier_ allow pass to the script different "identifiers" for "menu_items" by default is set to
      _items_identifier: ['menu_items', 'dishes']_ which exists on the json file.
+ Have to arrays _errors = []_ and _successes = []_ as a kind of logging.
    + _successes_ array will store the id of successfully created restaurant (by success I mean sucessfully  created restaurant, menus and menu_items)
    + _errors_ array will store the name of restaurant if some exception or error happen during the population
      of the restaurant, menu or menu_item.
+ Use of **ActiveRecord::Base.transaction** which will ensure rolling back everything when is needed.
+ The script is over verbose for easy identify where an error happen.
+ The script will Roll Back if _dry_run:true_ or if _errors_ array is not empty.

## Running the script
+ Enter to rails console with _rails c_
+ In the rails console load the script with _load "#{Rails.root}/app/scripts/populate_menu/populate_menu_data.rb"_
+ Call the populate method _populate_menu_data()_. Remember this method can receive two parameters, _dry_run_ and _items_identifier_
  which I explained above.

## Improvement of menu system
### Final developer notes
+ Create other model an table to avoid duplicate names for menu in the database.
  Similar to _menu_item_prices_ table we can have a _restaurant_menu_ table whith association to
  _restaurants_ and _menus_, this way we can leave _menu names_ as unique in _menus_ table.
+ Improve script for populate the menu system, for a huge amount of records a good approach
  is to create jobs with a worker, like _sidekiq_ worker, to ensure not consume much resources
  of the machine while the system is populating.
+ In the json file, I can see a menu_item_prices duplicate, the menu system allow this duplicate record,
  since this could happen by a mistake from user or a expected behaviour of the system.
