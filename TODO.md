# To-Do List for RAppian

+ for summarizeProcModel/customOutputs, 
   + handle when the assignment is to a field in a record type and not just NA in the target.
   + convert the code to map the UUID expressions to regular names.

+ for summarizeProcModel/customOutputs, if appends to, indicate this.  We remove the & but don't
   keep that information.

+ For EFormsDec13
```
Warning message:
In ans[multipart] <- if (!paths) sapply(murn, function(x) x[length(x)]) else sapply(murn,  :
  number of items to replace is not a multiple of replacement length
```

+ for an expression or interface or any SAIL code,   determine for rule inputs
  which are 
   + inputs-only, 
   + outputs only, 
   + input-outputs

+ understand Schema/XML documents
  + Rscripts/allXMLElements.R

+ find all SAIL code in all places in different XML files
   + See Rscripts/findSAILCode.R 
   + definition
   + custom outputs and inputs in process models
   + in recordType: views, filters
   + site: visibilityExpr
   + recordType: nameExpr

+ find the interfaces that are reused.
   + see funs.R
   + look for all references in the XML files, not just the code
   + or look at the XML-specific structure for different types, e.g.,
      + interfaceInformation in process model
	      + see interfaceInfo() in processModel.R
	  + used in SAIL code layouts
      + expression rules code.
   + with rcode2 being the rewritten code for every object in map
   + See AppSummary.md

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

+ sub-process information
   + for a node in a process model.
```
o = procNodes("processModel/0002ea7f-5596-8000-fc23-7f0000014e7a.xml")
o$ACPs[[19]]$value[2]
which(o$ACPs[[19]]$value[2] == map$uuid)
map$name[ o$ACPs[[19]]$value[2] == map$uuid ]
```

+ sub process 
    + the inMap ACP for the sub-process above has a secondary large set of acps. 
	+ This has type Bean?list
	+ This is the value of the <a:value> object.
	+ Now being processed via doACPs and converted to a data.frame and
	  the column in the top-level data.frame becomes a list.

+ [check] proc model: custom inputs and custom variables

+ [check] record type filters
   + see recTypeFilters()

+ proc model:  custom outputs in ac - output-exprs - el
   + node-level
   + identifies the variable being assigned
   + the expression to get the value.
   + see processModel/0002ea7f-5596-8000-fc23-7f0000014e7a.xml as example (ExportedV1_2/)
      and RoutingAssigning.md
```
z = customOutputs("processModel/0002ea7f-720f-8000-fc2f-7f0000014e7a.xml")
k = StoR(z$"Construct Data"[[1]]["code"], TRUE)[[1]]
rewriteCode(k, map)
```

+ Compute the flow of data through a process model
   + inputs from an interface
   + transfer of data to another interface
   + and back to the process
   + outputs from a node
   + custom outputs
   + e.g. in QE determine where we get the requestId

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

+ √ Show call graph for 2 or more functions.
```
plot(toGraph(lgraph(c("EFRM_INT_getPersonInfoByLoginId", "EFRM_SEC_graduateFormsForLandingPage", "EFRM_getAllUserGroupAndRoleCodes"), rcode2)))
g = toGraph(lgraph(c("EFRM_INT_getPersonInfoByLoginId", "EFRM_SEC_graduateFormsForLandingPage", "EFRM_getAllUserGroupAndRoleCodes", "EFRM_FORM_qeApplication", "EFRM_FRM_landingPage"), rcode2))
plot(g, layout = layout.drl, edge.arrow.size = .5, vertex.label.cex = .5)
w = V(g)$name == "EFRM_INT_getPersonInfoByLoginId"
plot(g, layout = layout.drl, edge.arrow.size = .5, vertex.label.cex = .5, vertex.color = c("red", "green")[ 1L + ])
plot(g, layout = layout.drl, edge.arrow.size = .5, vertex.label.cex = .5, vertex.color = c("red", "green")[ 1L + w], vertex.shape = c("none", "circle")[ 1L + w])
```

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
