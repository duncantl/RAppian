
#
# Goal here is to check that the code calling a sub-process model
# matches the parameters defined in that sub-process model.
# 
#

if(FALSE) {
    f = mapFile("EFRM Send Email Notification For QE Application", map)
    pn = procModelNodes(f, map)
    names(pn$ACPs) = pn$label

    w = pn$icon == "Subprocess"
    sub = pn$ACPs[w]

    # Check one sub-process node
    # "GPC Send Email"
    checkSubProcessCall(sub[[6]], map) 

    # Check all sub-process nodes
    xx = lapply(sub, checkSubProcessCall, map)
}

checkSubProcessCall =
    #
    # x is an ACPs element from procModelNodes and expected to be a a call to a (sub) ProcessModel
    #
function(x, map)
{
    i = x$type == "a:ProcessModel"
    i = which(x$value[i] ==  map$uuid)

    if(length(i) != 1)
        stop(paste("can't uniquely resolve UUID in map"))

    # get the proc model variable info
    pm = procModelVars(map$file[i], map)

    # The code that calls the sub-process model.
    # i.e., the code that provides the parameters passed to the sub-process.
    
    params = x$code[which(x$name == "ProcessParameters")]
    code = rewriteCode(params, map)
    checkSubProcessParams(code, pm, map)
}

checkSubProcessParams =
function(code, pm, map = NULL)    
{
    if(isSymbol(code, "null"))
        return(NULL)
    
    if(!is.call(code))
        stop("not a call - later")

    if(is.symbol(code[[1]])) {
        
        switch(deparse(code[[1]]),
               IF = lapply(code[3:length(code)], checkSubProcessParams, pm, map),
               matchReturnTypeToProcModel(code, pm, map)
#               "a!forEach" = 
               )
    } else
        stop("call is not a symbol")
}

matchReturnTypeToProcModel =
function(code, pm, map)
{
    fn = deparse(code[[1]])
    fn = gsub("^rule!", "", fn)

    if(fn == "SBrace") 
        rv = code
    else {
        i = match(fn, map$name)
        fnCode = rewriteCode(map$code[i], map)

        rv = returnValues(fnCode, map)
    }
    
    if(is.list(rv))
        sapply(rv, compareValToProcModel, pm, map)
    else
        compareValToProcModel(rv, pm, map)
}


compareValToProcModel =
function(val, pm, map)
{
    ins = names(val)[-1]
    m = match(ins, pm$name)
    no = ins[is.na(m)]
    maybe = sapply(no, function(x) agrep(x, pm$name, value = TRUE))
    # Return the elements that
    #    don't match a process parameter name
    #    could be a possible match using (simple) fuzzy matching
    #    process parameter not specified
    #    process parameters that are matched and specified.
    list(unmatched = no,
         maybe = maybe,
         missing = setdiff(pm$name, ins),
         matched = intersect(pm$name, ins)
        )
}


returnValues =
function(code, map)    
{
    a = deparse(code[[1]])
    if(a == "a!localVariables") 
        return ( returnValues(code[[length(code)]], map) )
    
    if(a == "IF") 
        return ( lapply(a[[ - (1:2) ]], returnValues,  map) )

    if(a == "SBrace")
        return(code)
    
    fn = gsub("rule!", "", a)
    i = match(fn, map$name)
    returnValues( rewriteCode( map$code[i], map), map )
}
