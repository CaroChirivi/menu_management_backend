# Requirements Menu Management Backend

The next levels of requirements are in individual branches, which try to show an iterative approach.

* Level 1: Basics
  + Create an object model for **Menu** and **MenuItem** s classes.
  + **Menu** has many **MenuItem** s.
  + **Menu** and **MenuItem** have typical data associated with restaurants.
  + Illustrate behavior via unit tests.
  
* Level 2: Multiple Menus
  + Introduce a **Restaurant** model, and allow **Restaurant** s to have multiple **Menu** s.
  + **MenuItem** names should not be duplicated in the database.
  + **MenuItem** can be on multiple **Menu** s of a **Restaurant** .
  + Illustrate behavior via unit tests.
  
* Level 3:
  + Convert the following json body from the included file, **restaurant_data.json** in to
our new menu system.
  + Make any model/validation changes that you feel are necessary to make the
import as complete as possible.
  + The output should return a list of logs for each menu item and a success/fail
result.
  + Apply what you consider to be adequate logging and exception handling.
  + Illustrate behavior via unit tests.

