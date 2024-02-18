# Could adjust CodeAnalysis::callGraph to avoid using get()
# and resolving things relative the appian app and know about builtins.
# But we'll do this later


#
#  Want to do this also to include what Record Types are used and constants.
#  Can use funOp to specify a different function that can be different or call findAppianCalledFuns as well.
# Or create one call graph for functions and another for, e.g., constants and then stack them.
#
if(FALSE) {
    a = callGraph("EFRM_FORM_TaskReassignmentForm", rcode2, funOp = findAppianConstants)
    
    b = callGraph("EFRM_getProgramUnitAndItsTaskMasterIds", rcode2, funOp = findAppianConstants)

     # Note the use of *rcode*, not *rcode2* since rcode2 has already be rewritten and the urn:appian references are gone.
    c = callGraph("EFRM_FRM_qeReportGradStudiesReview", rcode, funOp = findAppianRecordTypeUses, map = map)
}


callGraph =
    # , map = mkSummary()) # will we need map?
    #
    #
function(funNames, codeObjs, asDf = FALSE, funOp = findAppianCalledFuns, ...) 
{
    hasOp = missing(funOp)
    ans = vector("list", length(funNames))  # will grow anyway.

    while(length(funNames)) {
        fun = funNames[[1]]
        code = codeObjs[[fun]]
#        browser()
        ans[[fun]] = tmp = unique( funOp(code, ...))
        if(hasOp)
            tmp = findAppianCalledFuns(code)
        funNames = unique(c(funNames[-1], tmp[ !(tmp %in% names(ans)) & tmp %in% names(codeObjs)]))
    }

    ans = ans[ sapply(ans, length) > 0 ]

    if(asDf)
        data.frame(calls = rep(names(ans), sapply(ans, length)),
                   called = unlist(ans))
    else
        ans
}

findAppianCalledFuns =
function(code)
{
    k = findCallsTo(code)
    ids = sapply(k, function(x) deparse(x[[1]]))
    gsub(".*!", "", grep("^(rule|interface|outboundIntegration)", ids, value = TRUE))
}

findAppianConstants =
function(code)
{
    ids = getAllSymbols(code)
    # getAllSymbols() already converted the symbols to strings. So no need to deparse/as.character
    gsub(".*!", "", grep("^(constant|cons)!", ids, value = TRUE))
}

findAppianRecordTypeUses =
function(code, map = mkSummary())
{
    ids = getAllSymbols(code)
    sapply( grep("^#urn:appian:record-(type|field):", ids, value = TRUE),  function(x) rewriteCode(as.name(x), map))
}

