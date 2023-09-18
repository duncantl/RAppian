# To-Do List for RAppian

+ proc model: get interfaceInformation from a process model XML file
   + in a node and at the top-level too.
   + probably only one node at most has it - the start one.
      + No - 6 have 2, 18 have 1 and 
	  + The ones with 2 are all initiation processes 
	      +  all have a confirmation screen.
   + see EFRM_FORM_qeGradStudiesReview
   + name, uuid and {ruleInput}
       + each rule input has a name, type and value.
	      + value comes from corresponding pv!... ?
		  
+ proc model:  custom outputs in ac - output-exprs - el
   + node-level
   + identifies the variable being assigned
   + the expression to get the value.
   + see processModel/0002ea7f-5596-8000-fc23-7f0000014e7a.xml as example (ExportedV1_2/)
      and RoutingAssigning.md


+ diff() method for comparing two applications, e.g., dev versus test, or two different snapshots.
   + what objects are present in one and not the other
   + by object type.
   
+ [start√] given a SAIL code object, show only the call graph for it and its callees.
   + start with lgraph
   + `plot(toGraph(lgraph("EFRM_getNextAssigneeByProgramCodeAndRoleCodes", rcode2)))`

+ call graph of which object uses other objects
   + see uses.R

+ which expression rules use which record types.
   + see uses.R

+ [partial] get the details from nodes in a process model
    + procModelNodes()

+ login() and be able to 
   + download the exported databases
   + dowload the export Application

# Done

+ √ find commented-out code

+ √ resolveURN for `#urn:appian:function:v1:a:update`

+ √ clean up the 5 urn's in asyms that start `##"`
   + presumably part of StoR()

+ √ finish off the 5 SAIL code instances StoR doesn't handle. 
   + See yacc/TODO.md

+ √ functions to find all the `dom!name` values.
   + See funs.R - StoR and findCallsTo()

+ √ after StoR, replace the UUIDs/urn:..  with the resolved names.
   + mapName( , mkSummary())
   
+ √ Need to deal with 3-part urn record-relationship such as
```
"#urn:appian:record-field:v1:45f955b0-a7d5-4cd7-8e21-c9e3fd6a30ae/9c79e2a7-7e70-4c4d-8a30-f33f0e29b315/2b8d6fff-b98b-409f-b05c-42940899691a"
```
   in EFRM_GRID_COMMON_ActionHistory  (in ExportedTest2/)
   + docs/{three,four}....md
   + code now in resolveMultiURN.
      + need to make resolveURN use for the relevant subset of the vector.
