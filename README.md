# Drone-Share

--------------------------------------------------------------------------------- Part 1 ---------------------------------------------------------------------------------
Business Requirements
You are working for Fanshawe College who are setting up a drone (small personal unmanned flying aircraft) sharing program and database called FanshaweDroneShare.  They would like to track the people borrowing/renting, and the specific drones and accessories in the program.

Drones and accessories like cameras, GPS, sensors, joysticks are kept at stations (often the local library branch but not always).  Each drone/accessory has a home station that Fanshawe employees will return it to occasionally (note there is no need to model/capture   this work). The system will also track the station the drones/accessories are currently at. The current station will only be changed when a drone/accessory is checked in, so the current station for a drone/accessory will never be unknown.  Note that Fanshawe may want to add other types of accessories in the future.

Stations have names and maximum number of drones that can be held, each of which are always stored. For each station, the system should be able to track the number of drones that are currently at the terminal.  Drones will always have identification markings regulated by Transport Canada, and drones and accessories have manufacturer name, weight (in grams), model names and serial numbers which are always available.  Some drones/accessories will also have a manufactured date (and some will not).

Pilots will set up accounts and will be charged for their use via those accounts. Accounts may cover more than one pilot, such as when a house of roommates sets up an account. Each pilot may also be associated with more than one account.

When a pilot checks out a drone/accessory, it will be kept track of in the system. A pilot is permitted to sign out multiple drones/accessories at the same time. For example, a single pilot may sign out a drone for personal use as well as a drone for a guest.  One drone/accessory will never be checked out to multiple pilots simultaneously.

The system will be used to store specific information when pilots open an account. It will need to track a pilot’s first name and last name, along with their Transport Canada drone pilot certificate number, SIN and date of birth. We also need to store the street address, city, province, and postal code for a pilot.  It is possible for multiple pilots to live at the same address (e.g. multiple pilots in the same house). It is also possible for one pilot to have multiple addresses in our system (e.g. home address, business address). The pilot’s name, SIN, drone pilot certificate and date of birth are all mandatory, but all other pilot information is optional.
For each account the opening date, current balance, and account number should be stored. The account number is a unique number created by another system at a bank, so will always be available. The opening date and current balance will also always be populated.

--------------------------------------------------------------------------------- Part 2 ---------------------------------------------------------------------------------
Business Requirements
You have been provided with a partially completed FanshaweDroneShare database for a system that tracks a drone/accessory sharing program. After some testing, it has been determined that the structure alone is insufficient to properly constrain the database, and testing also revealed performance concerns, especially when doing Select queries to join 2 tables together.  You have been asked to add constraints and indexes to satisfy these business and technical requirements.

The customer has told you that whenever drone/accessories are checked in or out by pilots, a scanner reads the serial number which is used to uniquely identify that drone/accessory in the database.  Searches on SerialNumber will need to be properly optimized and constrained.  To help identify & communicate with the Pilots who are primarily responsible for the Account, they will often do lookups to determine this information, so those searches must be optimized as well.

In testing, the customer found that a station's maximum capacity would sometimes incorrectly be set to a negative number. Since this is invalid, they would like to prevent negative numbers from being added to the MaxCapacity column. As well weight of Drone equipment must always be non-negative.  4

The customer has identified dates in the system (DroneEquipment.ManufacturedDate and Account.AccountOpenDate) that should never be a future date, so they must be equal to or less than the current datetime. When testing these tables, the customer discovered that Accounts will often be uniquely identified by AccountNumber, and Pilots may be uniquely searched for by TransportCanadaCertNumber. These lookups will need to be optimized.

To improve consistency, the customer has asked you to provide some appropriate defaults when complete account details are not available. When not provided, CurrentBalance should be set to 0 and AccountOpenDate should be set to the current date.  In addition, since most pilots will be from Fanshawe and the surrounding area, suitable defaults should be included for all appropriate address fields.

A review of queries on the Address table identified three queries that need to be optimized. The first query creates a sorted list of provinces and cities. This list is sorted by province first, then by city. The second query looks up records by province only. The last query looks up records by city only.

They would like lookups by the parent and child columns optimized for all foreign keys. They would also like you to optimize lookups in both directions across the junction tables - the customer has found that lookups will frequently be done in both directions across all foreign keys.  Covering indexes should be provided to quickly look up Pilots by Addresses, Addresses by Pilots, Pilots by Accounts, or Accounts by Pilots.

