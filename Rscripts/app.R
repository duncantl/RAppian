# Find the UUIDs in the application that are no in the mkSummary()
#

library(XML)
library(RAppian)

if(!exists("map", globalenv(), inherits = FALSE))
    source("basics.R")

doc = xmlParse(map$file[ map$type == "application" ])
#u = xpathSApply(docs[type == "application"][[1]], "//uuid", xmlValue)
u = xpathSApply(doc, "//uuid", xmlValue)
u[!(u %in% map$uuid)]


# Then grep for these to see where they are referenced. Or use InXML.R
# "9c433514-976f-49e0-92d1-5f4375c884b9"   EFRM Reassignment Log - not exported - invalid precdedent.
# "fda3a208-dcc9-4f03-b6c3-c0d052ef4a54"         only in application
# "_a-0000deff-58e6-8000-06a9-01ef9001ef90_6171"  only in application
