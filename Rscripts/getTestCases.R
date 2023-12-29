library(XML)
dir = "~/OGS/EForms/CodeReview/EFormsDec27"
# Could use
#source("basics.R")
# xml = map$file
# to associate with the map metadata
xml = xmlFiles(dir)
docs = lapply(xml, xmlParse)
names(docs) = sapply(docs, getName)

rt = lapply(docs, function(doc) getNodeSet(doc, "//typedValue[./type/name[starts-with(., 'RuleTestConfig')]]"))
w = sapply(rt, length) > 0

rt = rt[w]

# x[[1]] since a node set but each element of rt has one element.
els = lapply(rt, function(x) getNodeSet(x[[1]], ".//el"))
table(sapply(els, length))



# Explore one with largest number of test cases
v = els[["EFRM_legacy_GSReviewComputeNextPersonTaskInfo"]]

sapply(v, function(x) xmlValue(x[["name"]]))


