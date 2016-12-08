# ios-decal-final-proj

# Roomies  
## Authors
- Sam Steady 
- Aneesh Khera

## Purpose
We are aiming to create an app that streamlines cooperative living in college, specifically through the organized distribution and management of household chores.

## Features
* Assign chores to a specific user
* Assign chores without specifying a user, gives chore to user with lowest chore weight total
* When creating a chore, user specifies the weight (difficulty) of the chore (using slider specifying values from 1 to 10)
* User also specifies how often a chore repeats (1 week, 2 weeks or 1 month options).

## Control Flow
* Input screen - if no user data, prompt to set up new user household, else: show entire household as tableview with user's chore on top
* Setting up household: input all default users 
* Ability to check off chores, delete chore, add household member, remove household members
* Colorcodes chores as overdue (red), due soon (yellow), complete for this cycle (green), or white if none of the above.

## Implementation
### Model
* User.swift
* Chore.swift

### View

* CreateHouseHoldView
* MainTableView (shows users as tiles, where the app launches to after household is setup)
* PersonView (shows chores for individual person, allows user to check off item)
* DescriptionView (Shows chore details, including chore description)
* NewChoreView (add chores in this view)
* AllChoresView (shows all chores in one view beneath each user who is assigned to that chore)


### Controller
* CreateHouseHoldViewController
* MainTableViewController
* PersonViewController
* DescriptionView
* NewChoreViewController
* AllChoresViewController
