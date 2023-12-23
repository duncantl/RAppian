dir = "~/OGS/EForms/CodeReview/EFormsDec22"
source("basics.R")

u = lapply(rcode, findAppianRecordTypeUses, map)
u = u[sapply(u, length) > 0]

u2 = lapply(u, function(x) x[ sapply(x, function(x) grepl("Request Details", as.character(x))) ])
w = sapply(u2, length) > 0
u3 = u2[w]

u4 = sapply(unlist(u3), as.character)
names(u4) = rep(names(u3), sapply(u3, length))
showCounts(dsort(table(u4)))
#                                            count
# EFRM Request Details.requestId                95
# EFRM Request Details.status                   26
# EFRM Request Details.initiatedBy              25
# EFRM Request Details.eFormId                  20
# recordType!EFRM Request Details               19
# EFRM Request Details.stage                    14
# EFRM Request Details.initiatedOn              10
# EFRM Request Details.externalJustification     8
# EFRM Request Details.isActive                  7
# EFRM Request Details.remoteJustification       6
# EFRM Request Details.completedBy               2
# EFRM Request Details.modifiedBy                2
# EFRM Request Details.workFlowId                2
# EFRM Request Details.completedOn               1
# EFRM Request Details.dueDateTime               1
# EFRM Request Details.folderId                  1
# EFRM Request Details.isOnBehalfOfReq           1
# EFRM Request Details.modifiedOn                1
# EFRM Request Details.priorityId                1
# EFRM Request Details.requestPendingDays        1

# Which rules access this record type and its elements the most
length(names(u4))
showCounts(dsort(table(names(u4))))

# Which rules which fields or the record type itself.
g = split(names(u4), u4)

