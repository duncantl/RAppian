usedBy = 
function(code, domain = "interface", fun = mkUsesFun(domain))
{
    iuses = lapply(code, fun)

    ind = matrix(0, length(iuses), length(iuses), dimnames = list(names(code), names(code)))
    for(i in names(iuses)) {
        tt = iuses[[i]]
        ind[i, names(tt)] = ind[i, names(tt)] + tt
    }
    ind
}

mkUsesFun =
function(domain)    
{
   domain = paste0(domain, "!")
   function(x)
       table(gsub(domain, "", grep(paste0("^", domain), getGlobals(x, FALSE)$functions, value = TRUE)))
}

mkUsesFun2 =
function(codeNames)
{
    function(x) {
        g = CodeAnalysis:::all_symbols(x)
        g = gsub(".*!", "", g)
        
        table(g[ g %in% codeNames ] )
    }
}


mergeCounts =
    #
    # Take two univariate table() results and
    # combine the counts for the elements in common and include the counts for those
    # elements not in common.
    # e.g.,   c(a = 1, b = 3, c = 2)  c(b = 2, w = 3)
    #  gives  c(a = 1, b = 5, c = 2, w = 3)
    #
function(x, y)
{
    w = names(y) %in% names(x)
    x[ names(y)[w] ] = x[ names(y)[w] ] + y[w]
    x[names(y)[!w] ] = y[!w]
    x
}


procModelUses =
    #
    # Find what application objects the process model uses and count how often.
    # Looks in the customInputs code, customOutputs code and which interfaces
    # the process model uses.
    #
    # Doesn't pick up integrations used in integration nodes.
    #
function(file, map, fun = mkUsesFun2(map$name))
{
    doc = xmlParse(file)
    q = customInputs(doc, map)
    a = fun(q$code)
#    a = fun(lapply(q$code[q$code != ""], function(x) rewriteCode(StoR(x, TRUE), map, parse = FALSE)))

    q = customOutputs(doc, map)
    b = fun(q$code[q$code != ""])

    a = mergeCounts(a, b)

    iface = interfaceInfo(doc, map)
    mergeCounts(a, table(names(iface)))
}
