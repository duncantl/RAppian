# RAppian

This is currently a relatively simple package to analyze (XML) data exported
from an Appian instance for an application or package.
The exported information includes all the relevant objects we see in the Appian Designer.

The Appian Designer allows us to get almost all of the data we explore via this package.
However, it is a different interface and exploration model, specifically, not programmatic.

It is convenient to have the information in R as
+ we can explore the objects programmatically,
+ asking different questions than in the designer, and
+ it is faster as the designer is somewhat slow to respond and also to click through multiple steps
  to get to a specific object and then connect to another object.


We can compare 

+ test and dev versions of the application
+ different snapshots as they evolve over time
+ find all the functions called in the sail code, both Appian functions and application-defined functions/rules,
+ catalog all the expression rules, constants and interfaces we might be able to reuse
+ find the connections between record types for all record types together.

