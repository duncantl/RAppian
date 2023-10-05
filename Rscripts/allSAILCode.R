# start with rcode2 and map and ind.all from funs.R

# Doesn't take into account uses of
#  record types as types of rule inputs

# Have code from rule and interface

# √ site
# process model
# outboundIntegration
#
# What else do we need from interface
#   ruleInputs(, map)
# gives the type, but that is not in our incidence matrix.

fun = mkUsesFun2(map$name)


# Site

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
#
#
#  customOutputs
#
idx = which(map$type == "processModel")
for(i in idx) {
    tt = procModelUses(map$file[i], map, fun)
    ind.all[i, names(tt)] = ind.all[i, names(tt)] + tt
}

nu = colSums(ind.all)
use = data.frame(name = map$name, type = map$type, numUsesOf = nu, usesNum = rowSums(ind.all))

use = use[order(use$numUsesOf, decreasing = TRUE), ]
