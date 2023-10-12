# Rscripts/

## For exploring an Appian package/application.

+ funs.R
   + construct big-picture view of the application and all the objects
     + map (from mkSummary()) that describes each object
	 + rcode2 - map SAIL code to R and substitute UUIDs with human-readable names.

+ findSAILCode.R
   + programmatically find the nodes in all the XML files that appear to contain SAIL code.

+ allSAILCode.R
   + finds sail code 

+ whereSAILCode.R
   + finds all XML nodes in all documents that contain !, ideally identifying instances of SAIL code
   + see table below
   
+ dupConstants.R
   + find duplicated constants, in particular, the strings that have the same value but are
     referenced by 2 or more constants.

+ documentation.R
   + brief analysis of what objects have a description, descriptions for rule inputs 

+ allXMLElements.R
   + summary of what XML elements occur in which types of documents and how often.
   
+ app.R
   + get all the UUIDs in the sole <application> object.

+ findInterface.R
   + Find where each top-level object UUID is used, including for interfaces specifically.

+ summary2.R
   + find uses of top-level UUIDs.
   
+ summaryXML.R
   + Early summary of code in XML documents. Needs to be enhaced to cover more nodes that can
     contain SAIL code. See allSAILCode.R and whereSAILCode.R above.





# XML Nodes Containing !

```
                      
                       interface outboundIntegration processModel recordType rule site
  contextExpr                  0                   0            0          1    0    0
  customFieldExpr              0                   0            0          2    0    0
  defaultFiltersExpr           0                   0            0          1    0    0
  definition                 137                   0            0          0  437    0
  el                           0                   0          307          0    0    0
  expr                         0                   0          934          0    0    0
  expression                   0                   0          259          0    0    0
  facetExpr                    0                   0            0          5    0    0
  listViewTemplateExpr         0                   0            0         30    0    0
  relativePath                 0                   2            0          0    0    0
  resultAssertions             0                   0            0          0    4    0
  titleExpr                    0                   0            0         30    0    0
  uiExpr                       0                   0            0          3    0    0
  value                        3                   4          326          0    4    0
  visibilityExpr               0                   0            0          0    0    3
```
