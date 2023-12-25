# Same as findRequestDetailsUses.R
# This and findRequestDetailsUses.R miss the code in
# the record type filters, views
# and the process models.
#
dir = "~/OGS/EForms/CodeReview/EFormsDec22"
source("basics.R")

u = lapply(rcode, findAppianRecordTypeUses, map)
u = u[sapply(u, length) > 0]


u3 = lapply(u, function(x) x[ sapply(x, function(x) grepl("eForm", as.character(x))) ])
w = sapply(u3, length) > 0
u3 = u3[w]

u4 = sapply(unlist(u3), as.character)
names(u4) = rep(names(u3), sapply(u3, length))
showCounts(dsort(table(u4)))


# eForm.name is used in 24 places.
