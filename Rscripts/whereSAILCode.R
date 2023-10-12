# Find the names of the XML nodes that directly contain SAIL code in all the XML documents for an appian application.
# To do this, we currently search for text() nodes that contain the character  and get the name of the parent node.
# We can refine this.

nodesContainingBang = lapply(map$file, function(x) xpathSApply(xmlParse(x), "//text()[contains(., '!')]", function(x) xmlName(xmlParent(x))))

tmp = data.frame(xmlNode = unlist(nodesContainingBang),
                 inType = rep(map$type, sapply(nodesContainingBang, length)))

showCounts(dsort(table(tmp$xmlNode)))

table(tmp$xmlNode, tmp$inType)
