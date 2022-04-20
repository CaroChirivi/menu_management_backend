# Requirements Menu Management Backend

The next levels of requirements are in individual branches, which try to show an iterative approach.

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
