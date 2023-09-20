# Rscripts/

## For exploring an Appian package/application.

+ funs.R
   + construct big-picture view of the application and all the objects
     + map (from mkSummary()) that describes each object
	 + rcode2 - map SAIL code to R and substitute UUIDs with human-readable names.
+ findSAILCode.R
   + programmatically find the nodes in all the XML files that appear to contain SAIL code.

+ dupConstants.R
   + find duplicated constants, in particular, the strings that have the same value but are
     referenced by 2 or more constants.
