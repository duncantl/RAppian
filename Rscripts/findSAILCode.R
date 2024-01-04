# Find all the nodes in all the XML files that appear to contain SAIL code.

library(XML)

if(!exists("map", globalenv(), inherits = FALSE))
    source("basics.R")

# The following is not quite right as miss `#urn` or `#_a......(`
# Now seems to get them
xpath = "//*[contains(./text(), '!') or contains(./text(), 'SYSTEM_SYSRULES_') or
          contains(./text(), '#\"urn') or contains(./text(), '#\"_') ]"


bang = lapply(map$file, function(x) getNodeSet(xmlParse(x), xpath))
map$numBangs = sapply(bang, length)

# Those types that appear to have no !
table(map$type[map$numBangs == 0])


nodeNames = lapply(bang, function(x) sapply(x, xmlName))

table(unlist(nodeNames))

# For each node name that seems to contain SAIL code, which object types have that node name
tapply(rep(map$type, sapply(nodeNames, length)), unlist(nodeNames), unique)

# For each object type, list the node names that appear to contain SAIL code
nameByType = tapply(unlist(nodeNames), rep(map$type, sapply(nodeNames, length)), unique)




# Just for process models for now.
ff = list.files(file.path(dir, "processModel"), full = TRUE)
k = lapply(ff, function(x) getNodeSet(xmlParse(x), "//x:value[. != ''] | //x:recipients-exp[. != '']  | //x:expr[. != '']  | //x:expression[. != ''] | //x:el[. != '']  | //x:minutesExpr[. != ''] " , AppianTypesNS))

table(sapply(k, length))
# Some with exact same count. Are they the same
sapply(k[sapply(k, length) == 58], all.equal, k[sapply(k, length) == 58][[1]])
