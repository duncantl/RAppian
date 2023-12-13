i = which(map$name == "EFRM_getProgramUnitAndItsTaskMasterIds")
k = rcode2[[ i ]][-1]
unitName = sapply(k,  function(x) x[[2]])
names(k) = unitName
role = sapply(k,  function(x) RAppian:::mapConsValue(x[[3]], map))
tids = lapply(k,  function(x) as.list(x[[4]])[-1])
tids2 = lapply(tids,  function(x) sapply(x, RAppian:::mapConsValue, map))

# The dump of EFRM_INT_TASK_MASTER_ID_FILING_PROCESS does not contain the values,  so get NAs

# Now map these ids to rows in the TASK_MASTER

if(exists("dbs")) {
    # dbs = readDBDump("DBDumps/127_0_0_1_afterClose.json", efrmOnly = FALSE)
    tm.table = dbs$TASK_MASTER
    tms = lapply(tids2, function(x) 
             tm.table[as.integer(x), ]
          )
}

# 

j = which("EFRM_FORM_TaskReassignmentForm" == map$name)
fns = findCallsTo(rcode2[[j]])
tb = table(sapply(fns, function(x) deparse(x[[1]])))
tb[ grep("^(rule|interface)", names(tb)) ]
