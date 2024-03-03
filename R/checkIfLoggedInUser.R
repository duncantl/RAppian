checkIfLoggedInUser =
    #
    # Checks for code I use when developing/testing  in Appian Designer of the form
    #  if(true/false, "<username>", loggedInUser())
    #
    # Need to ensure that before deploying we set this to false or go back to just loggedInUser() - no if().
    #
function(rcode, hardCoded = TRUE)
{    
    ifs = getIfs(rcode)
    luser = lapply(ifs, function(ifCalls) ifCalls[ sapply(ifCalls, function(x) x[[4]] == quote(loggedInUser()) || x[[3]] == quote(loggedInUser())) ])
    luser = luser[ sapply(luser, length) > 0 ]
    if(hardCoded)
        findHardCodedIfConditions(luser)
    else
        luser
}

getIfs =
function(rcode)    
{
    ifs = lapply(rcode, findCallsTo, "IF")
    ifs = ifs[sapply(ifs, length) > 0]    
}


findHardCodedIfConditions =
    #
    # returns the list with the list of IF(true/false, ...) calls
    #
function(rcode)
{
    ifs = getIfs(rcode)
    ifs2 = lapply(ifs, function(ifCalls) ifCalls[ sapply(ifCalls, function(x) isLiteralBoolean(x[[2]])  ) ])
    ifs2 = ifs2[ sapply(ifs2, length) > 0 ]
}

isLiteralBoolean =
function(x)
{
    paste(deparse(x, 300), collapse = "") %in% c("true", "false", "true()", "false()")
}
