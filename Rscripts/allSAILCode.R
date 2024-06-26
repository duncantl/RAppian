# start with rcode2, map and ind.all from funs.R

if(!exists("ind.all"))
    stop("need ind.all from funs.R")

# Doesn't take into account uses of
#  record types as types of rule inputs

# Have code from rule and interface

# √ site
# process model
# outboundIntegration
# record types and filters and views
#
# What else do we need from interface
#   ruleInputs(, map)
# gives the type, but that is not in our incidence matrix.

fun = mkUsesFun2(map$name)


# Site

# Currently this code assumes only one site.  But there are now 3.
w = map$type == "site"
si = siteInfo(map$file[w])
a = mapUUID(si$uuid, map, "name")
#lapply(si$visibility, function(x) fun(rewriteCode(StoR(x, TRUE), map)))
b = fun(lapply(si$visibility, function(x) rewriteCode(StoR(x, TRUE), map)))
ab = mergeCounts(table(a), b)
ind.all[w, names(ab)] = ind.all[w, names(ab)] + ab


# process models
# code in customInputs and customOutputs
# X procNodes() has ACPs, but these are process variables and record types
#
#  customInputs
#    code
#    value
#
#  customOutputs
#
# See pmCode.R also.
idx = which(map$type == "processModel")
for(i in idx) {
    tt = procModelUses(map$file[i], map, fun)
    ind.all[i, names(tt)] = ind.all[i, names(tt)] + tt
}

# record types -
#  code in the views, filters, 
ty = which(map$type == "recordType")
for(i in ty) {
    code = getRecordTypeCode(map$file[i], map)
    tts = lapply(code, fun)
    tt = Reduce(mergeCounts, tts)
    ind.all[i, names(tt)] = ind.all[i, names(tt)] + tt
}


nu = colSums(ind.all)
use = data.frame(name = map$name, type = map$type, numUsesOf = nu, usesNum = rowSums(ind.all))

use = use[order(use$numUsesOf, decreasing = TRUE), ]
