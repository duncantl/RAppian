xml = xmlFiles()
docs = lapply(xml, xmlParse)
names(docs) = xml
nodeNames = lapply(docs, function(doc) xpathSApply(doc, "//*", xmlName))
type = sapply(docs, getDocType)

nodeNames2 = unlist(nodeNames)
type2 = rep(type, sapply(nodeNames, length))

length(unique(nodeNames2))
showCounts(dsort(nodeNames2))

# node names by type of object
tt = tapply(nodeNames2, type2, table)


##########

tt$constant
names(tt$constant)[tt$constant == sum(type == "constant")]
tt$constant[tt$constant != sum(type == "constant")]
# appears that each file has 6 groups, role and users nodes.

# unlogged
table(sapply(docs[type == "constant"], function(doc) length(getNodeSet(doc, "//unlogged | //x:unlogged", AppianTypesNS))))
table(sapply(docs[type == "constant"], function(doc) xmlSize(getNodeSet(doc, "//unlogged | //x:unlogged", AppianTypesNS))))
table(sapply(docs[type == "constant"], function(doc) xmlValue(getNodeSet(doc, "//unlogged | //x:unlogged", AppianTypesNS))))
