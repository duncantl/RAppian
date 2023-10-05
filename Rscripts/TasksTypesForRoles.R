if(FALSE) {
    v = as.list(rcode2$EFRM_getProgramUnitAndItsTaskMasterIds)[-1]
    # The values corresponding to EFRM_INT_TASK_MASTER_ID_FILING_PROCESS
    # are all NA. This is because the values are not exported for this constant.
    # It may be because this constant is "Environment Specific"
    # 15 16 43 44 45 46 47 48 49 50 51 52
    o = lapply(v, mkTaskRoleUnitMap, map)
}



