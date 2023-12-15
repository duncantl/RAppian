source("basics.R")

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
