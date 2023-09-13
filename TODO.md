# To-Do List for RAppian

+ Need to deal with 3-part urn record-relationship such as
```
"#urn:appian:record-field:v1:45f955b0-a7d5-4cd7-8e21-c9e3fd6a30ae/9c79e2a7-7e70-4c4d-8a30-f33f0e29b315/2b8d6fff-b98b-409f-b05c-42940899691a"
```
   in EFRM_GRID_COMMON_ActionHistory  (in ExportedTest2/)

+ diff() method for comparing two applications, e.g., dev versus test, or two different snapshots.
   + what objects are present in one and not the other
   + by object type.

+ call graph of which object uses other objects

+ which expression rules use which record types.

+ find commented-out code


# Done

+ √ finish off the 5 SAIL code instances StoR doesn't handle. 
   + See yacc/TODO.md

+ √ functions to find all the `dom!name` values.
   + See funs.R - StoR and findCallsTo()

+ √ after StoR, replace the UUIDs/urn:..  with the resolved names.
   + mapName( , mkSummary())
   
