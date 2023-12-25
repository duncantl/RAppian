source("basics.R")
i = grep("EFRM_startProcessLinkForPendingTask", map$name)
k = rcode2[[i]]
m = findCallsTo(k, "a!match")
m = m[[1]]
names(m)
w = names(m) %in% c("equals", "whenTrue")
# Actually no "equals" in this call, but could be.

els = as.list(m[w])

# Check all are calls to contains. Some don't have to be since only one element.
stopifnot(sapply(els, function(x) is.call(x) && isSymbol(x[[1]], "contains")))
# If this is not true, just need to add conditional code to handle them
# just like for equals.

vals = lapply(els, function(x) x[[2]])

vals2 = lapply(vals, function(x) if(is.call(x) && isSymbol(x[[1]], "SBrace")) as.list(x[-1]) else x[[2]])

vals3 = lapply(vals2, function(x) {
                       if(is.list(x))
                           x[ sapply(x, is.call) ]
                       else
                           list(x)
                       })

ids = lapply(vals3, function(x) 
                   sapply(x, mapConsValue, map))


db = readDBDump(dir = "../../CodeReview/DBDumps")
lkup = structure(db$TASK_MASTER$TASK_NAME, names = db$TASK_MASTER$TASK_MASTER_ID)

hvals = lapply(ids, function(x) lkup[ x ] )


w2 = sapply(hvals, function(x) any(is.na(x)))


