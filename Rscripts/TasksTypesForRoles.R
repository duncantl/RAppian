# source("basics.R")
if(!exists("rcode2", globalenv(), inherits = FALSE))
   source("basics.R")

library(RAppian)
    
v = as.list(rcode2$EFRM_getProgramUnitAndItsTaskMasterIds)[-1]
names(v) = sapply(v, function(x) x[[2]])
    # The values corresponding to EFRM_INT_TASK_MASTER_ID_FILING_PROCESS
    # are all NA. This is because the values are not exported for this constant.
    # It is because this constant is "Environment Specific". Probably shouldn't be.
    # 15 16 43 44 45 46 47 48 49 50 51 52
    # Can get information on values from description, but only as good as the person who wrote the description.
o = lapply(v, mkTaskRoleUnitMap, map)



