getTestCases =
function(x, map)
{
    if(is.character(x))
        x = mkDoc(mapFile(x, map))

    tests = getNodeSet(x, "//typedValue[./type/name[starts-with(., 'RuleTestConfig')]]//el")
    if(length(tests) == 0)
        return(NULL)

    ans = lapply(tests, getTestCaseInputs, map)

    names(ans) = sapply(tests, function(x) xmlValue(x[["name"]]))
    # ¿Make data.frame with identifier for which test each row comes from?
    
    ans
}


getTestCaseInputs =
    # Assertions
    #
    # For now x is an <el> an individual test case.
    # So get the set of inputs for this one test case
    #
function(x, map)
{
    w = names(x) == "ruleInputTestConfigs"
    tmp = lapply(xmlChildren(x)[w],  getTestCaseInputInfo, map)
    val = lapply(tmp, `[[`, "value")
    ans = do.call(rbind, tmp)
    ans$value = val
    ans
}

getTestCaseInputInfo =
    # A single parameter/input for a single test case.
    # a ruleInputTestConfigs
function(x, map)
{
    if(!("value" %in% names(x))) {
        return(data.frame(name = NA, value = NA, id = NA, type = NA, code = NA))
    }
    
    
    val = xmlValue(x[["value"]])
    
    ty = xmlGetAttr(x[["value"]], "type")

    ans = data.frame(name = xmlValue(x[["nameRef"]]),
                     value = if(length(ty)) {
                                 # XXX need to convert from string to type.
                                 if(ty == "a:Expression") NA else val 
                             } else
                                 # should check nil attribute is true
                                 #  xmlGetAttr(x[["value"]], "nil", "") == "true"
                                 NA,  # ? Convert this to NULL after creating the data.frame?
                     id = xmlValue(x[["id"]]),
                     type = if(length(ty)) ty else NA)

    ans$code = list(if(length(ty) && ty == "a:Expression")
                        rewriteCode(StoR(val), map)
                    else
                        NULL)
    ans
}
