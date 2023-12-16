source("basics.R")
source("InXML.R")

# Mirroring the steps for a new form in the forked document https://docs.google.com/document/d/1Pkv9TX00a4AAK9P2hTl2Jn0UsZphWW6d/edit

# Step 1 - Workflow table
# Where is it used?
u = map$uuid[ map$name == "EFRM Workflow"]
map$name[ which(sapply(xmlc, function(x) any(grepl(u, x)))) ]

# Only the App, eForm and Request Details and Workflow itself - so only record types.

z = sapply(rcode2, function(x) any(grepl("EFRM eForm", getAllSymbols(x))))
# Not picking up
# getTaskLogByUserFilters - not in export - part of E-Forms (not -1.0)
# getFormsBasedOnSearchQuery - not in export - part of E-Forms (not -1.0)
# SEC_TaskReassignmentFilters - not in export - part of E-Forms (not -1.0)

z = sapply(rcode2, function(x) any(grepl("EFRM eForm", getAllSymbols(x))))
z2 = data.frame(map$name[z], map$type[z])

# 20 of them are getProcessParameters..Email...
# Other 5 are
#                            EFRM_QR_getEFormDetails        rule
# EFRM_getGridColumnsForTaskReassignmentOpenTaskGrid   interface
#                     EFRM_GRID_TasksForLoggedInUser   interface
#                   EFRM_GRID_MyApplicationsReadOnly   interface
#                                EFRM_FRM_myStudents   interface


w = sapply(rcode2, function(x) "rule!EFRM_QR_getEFormDetails" %in% sapply(findCallsTo(x), function(x) deparse(x[[1]])))
kk = lapply(rcode2[w], function(x) { k = findCallsTo(x); k[ "rule!EFRM_QR_getEFormDetails" == sapply(k, function(x) deparse(x[[1]])) ]})
sapply(kk, length) == 1
kk = unlist(kk)
sapply(kk, function(x) names(x[-1]))


#XXX Note the rcode is not rcode2.
# Can we use callGraph for this?
u = lapply(rcode[w], RAppian:::findAppianRecordTypeUses, map)
# Actually, deparse and look at the type.field or type
tmp = lapply(rcode[w], function(x) sapply(RAppian:::findAppianRecordTypeUses(x, map), deparse))
tmp2 = data.frame(access = unlist(tmp), by = rep(names(rcode)[w], sapply(tmp, length)), row.names = NULL)
tmp2$record = gsub("\\..*", "", tmp2$access)
tmp2$field = gsub(".*\\.", "", tmp2$access)

tmp3 = subset(tmp2, record == "EFRM eForm")
table(tmp3$field)


z = lapply(rcode2[w], function(x) {k = findCallsTo(x); k[sapply(k[-1], function(x) is.name(x) && as.character(x) == "EFRM eForm.name")]})
