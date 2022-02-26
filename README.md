# Menu Magik
A solution to the Popmenu Menu Management Backend challenge.

***General Functionality***

**Start with a restaurant.**

```
restaurant = Restaurant.create(name: 'Big Dog BBQ',
                               street_address: '537 Hilldale Cir #19',
                               city: 'Winder',
                               region: 'Georgia',
                               postal_code: '30680',
                               country: 'United States',
                               phone_number: '813-952-0577')
```

**Multiple menus can be created for that restaurant.**

```
lunch_menu  = Menu.create(title: 'Lunch', restaurant: restaurant)
dinner_menu = Menu.create(title: 'Dinner', restaurant: restaurant)
```

**Multple menu items can be created for that restaurant**

```
salad      = MenuItem.create(title: 'Salad',
                             description: 'Fresh greens, tomatoes, onions, and bell peppers',
                             price: 13.00,
                             restaurant: restaurant)
roast_beef = MenuItem.create(title: 'Roast beef',
                             description: 'Our famous roast beef',
                             price: 18.00,
                             restaurant: restaurant)
```

**Menu items can be added directly to menus.**

```
lunch_menu.menu_items << salad

dinner_menu.menu_items << salad
dinner_menu.menu_items << roast_beef
```

**When a menu item is added to a menu it creates a new `menu_item_representation`.  This is a join table between ```Menu``` and ```MenuItem``` and represents any attributes unique to this representation of the item on the menu.**

**The MenuItemRepresentation also represents the placement on the menu through a heirarchical tree.  Menu items can as children items to a particular representation on a menu**


```
ceasar      = MenuItem.create(title: 'Ceasar Dressing',
                             description: 'Our house made ceasar dressing.',
                             price: 0.50,
                             restaurant: restaurant)
ranch       = MenuItem.create(title: 'Ranch Dressing',
                             description: 'Our house made ranch dressing.',
                             price: 0.50,
                             restaurant: restaurant)

lunch_salad_mir = MenuItemRepresentation.where(menu: lunch_menu, menu_item: salad).first

lunch_salad_mir.create_child_from_menu_item(ranch)
lunch_salad_mir.create_child_from_menu_item(ceasar)

```

** To visualize the menu structure you can call print_structure from the menu **


```
  lunch_menu.print_structure

```

```
=>
**************************************************
--------------------------------------------------
Salad
- Ranch Dressing
- Ceasar Dressing
--------------------------------------------------
**************************************************

```

```
  dinner_menu.print_structure

```

```
=>
**************************************************
--------------------------------------------------    
Roast beef                                            
--------------------------------------------------    
--------------------------------------------------    
Salad                                                 
--------------------------------------------------    
**************************************************    
```

** Entire menu representation structures can be copied as well.   Lets try adding the salad with the selection of dressing as an option under the roast beef.

```
  dinner_roast_beef_mir = MenuItemRepresentation.where(menu: dinner_menu, menu_item: roast_beef).first

  lunch_salad_mir.copy_self_and_descendents_to(dinner_roast_beef_mir)
```

** Now lets check out the structure again. **

```
  dinner_menu.print_structure

```

```
=>
**************************************************
--------------------------------------------------
Roast beef
- Salad
- - Ranch Dressing
- - Ceasar Dressing
--------------------------------------------------
--------------------------------------------------
Salad
--------------------------------------------------
**************************************************
```

** Users can be created and can have many orders**


```
  user = User.create(name: 'Clay Cribbs',
                     street_address: '537 Hilldale Cir #19',
                     city: 'Winder',
                     region: 'Georgia',
                     postal_code: '30680',
                     country: 'United States',
                     phone_number: '813-952-0577')
  )

  order  = Order.create(user: user, restaurant: restaurant)
  order2 = Order.create(user: user, restaurant: restaurant)
```

** Menu item representations can be added to the order, directly from a child, or as a parent item without children **

```
  lunch_ceasar_mir = lunch_salad_mir.children.where(menu_item: ceasar).first
  order.create_order_items_from_menu_item_representation(lunch_ceasar_mir)
  order.print_structure
```

```
=>
**************************************************
--------------------------------------------------                      
Salad                                                                   
-Ceasar Dressing                                                        
--------------------------------------------------                      
**************************************************   
```


```
order2.create_order_items_from_menu_item_representation(lunch_salad_mir)
order2.print_structure
```

```
**************************************************
--------------------------------------------------                       
Salad                                                                    
--------------------------------------------------                       
**************************************************   
```

```
order2.create_order_items_from_menu_item_representation(lunch_ceasar_mir)
order2.print_structure
```

```
**************************************************
--------------------------------------------------                       
Salad                                                                    
-Ceasar Dressing                                                         
--------------------------------------------------                       
**************************************************  
```


```
order2.create_order_items_from_menu_item_representation(lunch_ceasar_mir)
order2.print_structure
```

```
**************************************************
--------------------------------------------------                       
Salad                                                                    
-Ceasar Dressing                                                         
--------------------------------------------------                       
**************************************************  
```

A list of test cases covered, for an up to date list run

```
  rspec -f d --color --dry-run
```
Test cases covered:


```
MenuItemRepresentation
  #validate
    is valid if required fields are present
    is invalid if menu_id is not present
    is invalid if menu_id is set to nil
    is invalid if menu_item_id is not present
    is invalid if menu_item_id is set to nil
    uniqueness
      #menu_item_id
        when verifying it is scoped to :parent_id, :menu_id
          with an existing menu_item_representation
            that shares no attributes
              is valid
            that shares the same menu and parent
              is valid
            that shares the same menu_item and parent
              is valid
            that shares the same menu and menu_item
              is valid
            that shares the same menu and menu_item and parent
              is not valid
  associations
    it belongs_to menu
    it belongs_to menu_item
  #add_to_order
    with an order that is nil
      fails
    with a valid order
      with no children or parents
        creates an associated order_item
      with a populated family tree
        where no ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item for each ancestor that has none
        where some ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item for each ancestor that has none
        where all ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item
        where a granduncle shares the order
          creates an associated order_item for each ancestor that has none
        where a nephew shares the order
          creates an associated order_item for each ancestor that has none
        where another order shares the same representation
          creates an associated order_item for each ancestor that has none
  #create_child_from_menu_item
    creates a new menu_item_representation
    adds the new menu_item_representation to children
  #copy_self_and_descendents_to
    creates a new menu_item_representation for itself and each child
    duplicates the correct association tree
  #set_default_price_adjustment
    when price_adjustment is not provided
      when menu_item.price is populated
        assigns menu_item.price to price_adjustment
      when menu_item.price is nil
        assigns 0 to price_adjustment
    when a price_adjustment is provided
      when menu_item.price is populated
        assigns the provided value to price_adjustment
      when menu_item.price is nil
        assigns the provided value to price_adjustment

MenuItem
  #validate
    is valid if required fields are present
    is invalid if price is not present
    is invalid if price is set to nil
    is invalid if restaurant_id is not present
    is invalid if restaurant_id is set to nil
    is invalid if status is not present
    is invalid if status is set to nil
    is invalid if title is not present
    is invalid if title is set to nil
    uniqueness
      #title
        with a menu_item that does not share the same title
          that shares the same restaurant
            is not valid
          that does not share the same restaurant
            is valid
        with a menu_item that shares the same title
          that shares the same restaurant
            is not valid
          that does not share the same restaurant
            is valid
  associations
    it belongs_to restaurant
    it has_many menus
  #menus
    when associating with a menu
      persists its association to the original menu
      associates correctly
    when removing an association to a menu
      persists its association to the original menu
      removes the association correctly

Menu
  #validate
    is valid if required fields are present
    is invalid if restaurant_id is not present
    is invalid if restaurant_id is set to nil
    is invalid if status is not present
    is invalid if status is set to nil
    is invalid if title is not present
    is invalid if title is set to nil
  associations
    it belongs_to restaurant
    it has_many menu_items
  #menu_items
    has many menu_items
    when creating an associated menu_item
      increases menu_items count by 1
      does not increase other menu menu_items count
    when removing an associated menu_item
      increases menu_items count by 1
      does not decrease other menu menu_items count

OrderItem
  #validate
    is valid if required fields are present
    is invalid if menu_item_representation_id is not present
    is invalid if menu_item_representation_id is set to nil
    is invalid if order_id is not present
    is invalid if order_id is set to nil
  associations
    it belongs_to menu_item_representation
    it belongs_to order

Order
  #validate
    is valid if required fields are present
    is invalid if status is not present
    is invalid if status is set to nil
    is invalid if user_id is not present
    is invalid if user_id is set to nil
  associations
    it has_many order_items
    it belongs_to user
  #create_order_items_from_menu_item_representation
    with an menu_item_representation that is nil
      fails
    with a valid menu_item_representation
      with no children or parents
        creates an associated order_item
      with a populated family tree
        where no ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item for each ancestor that has none
        where some ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item for each ancestor that has none
        where all ancestors share the order
          where children share the order
            does not create an order_item
          where no children share the order
            creates an associated order_item
        where a granduncle shares the order
          creates an associated order_item for each ancestor that has none
        where a nephew shares the order
          creates an associated order_item for each ancestor that has none
        where another order shares the same representation
          creates an associated order_item for each ancestor that has none

Restaurant
  #validate
    is valid if required fields are present
    is invalid if city is not present
    is invalid if city is set to nil
    is invalid if country is not present
    is invalid if country is set to nil
    is invalid if name is not present
    is invalid if name is set to nil
    is invalid if phone_number is not present
    is invalid if phone_number is set to nil
    is invalid if postal_code is not present
    is invalid if postal_code is set to nil
    is invalid if region is not present
    is invalid if region is set to nil
    is invalid if status is not present
    is invalid if status is set to nil
    is invalid if street_address is not present
    is invalid if street_address is set to nil
  associations
    it has_many menus
    it has_many menu_items

User
  #validate
    is valid if required fields are present
    is invalid if city is not present
    is invalid if city is set to nil
    is invalid if country is not present
    is invalid if country is set to nil
    is invalid if name is not present
    is invalid if name is set to nil
    is invalid if phone_number is not present
    is invalid if phone_number is set to nil
    is invalid if postal_code is not present
    is invalid if postal_code is set to nil
    is invalid if region is not present
    is invalid if region is set to nil
    is invalid if status is not present
    is invalid if status is set to nil
    is invalid if street_address is not present
    is invalid if street_address is set to nil
  associations
    it has_many orders

Restaurant
  when ensuring it passes the Popmenu challenge
    is a valid class
    persists when saved to the database
    has relevant attributes
    #menus
      has many menus
      when creating an associated menu
        increases menus count by 1
        does not increase other restaurant menus count
      when removing an associated menu
        decreases menus count by 1
        does not decrease other restaurant menus count
    with associated menu_items
      has many menu_items
      when creating an associated menu_item
        increases menu_items count by 1
        does not increase other restaurant menu_items count
      when removing an associated menu_item
        decreases menu_items count by 1
        does not decrease other restaurant menu_items count

Menu
  when ensuring it passes the Popmenu challenge
    is a valid class
    persists when saved to the database
    has relevant attributes
    #menu_items
      has many menu_items
      when creating an associated menu_item
        increases menu_items count by 1
        does not increase other menu menu_items count
      when removing an associated menu_item
        increases menu_items count by 1
        does not decrease other menu menu_items count

MenuItem
  when ensuring it passes the Popmenu challenge
    is a valid class
    persists when saved to the database
    has relevant attributes
    #title
      with a menu_item that does not share the same title
        that shares the same restaurant
          is not valid
        that does not share the same restaurant
          is valid
      with a menu_item that shares the same title
        that shares the same restaurant
          is not valid
        that does not share the same restaurant
          is valid

User
  when ensuring it passes the Popmenu challenge
    is a valid class
    persists when saved to the database
    has relevant attributes
    #orders
      has many orders
      when creating an associated order
        increases orders count by 1
        does not increase other user orders count
      when removing an associated order
        decreases orders count by 1
        does not decrease other user orders count

Order
  when ensuring it passes the Popmenu challenge
    is a valid class
    persists when saved to the database
    has relevant attributes
    when creating an order for a dinner salad
      as a standalone dish
        can be ordered
        with a selection of dressing
          can be ordered
      as a side of another item
        can be ordered
        with a selection of dressing
          can be ordered

```
