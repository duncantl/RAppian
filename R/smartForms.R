#
# Get information about the "generic" smart forms.
#
# These expands the code for each form to replace constants and local variables that are shared
# across forms.
#
#

getSmartFormsDescriptions =
function(code = rcode2$EFRM_smartGenericFormInfo, map)
{
    code = replaceConstants(code, map)
    vars = mkVars(code)    
    desc = code[["local!actualForms"]]

    lapply(as.list(desc)[-1], mkSmartFormDesc, vars)
}

mkSmartFormDesc =
function(m, vars)
{
    # now replace any variables.
    # remove the a!map().
    desc = as.list( m[-1] )
    lapply(desc, langReplace, vars)
}

mkVars =
    #
    #
    #
function(code)    
{
    vars = code[ grepl("^local!", names(code) ) ]
    for(i in seq(along.with = vars)) 
        vars[[i]] = langReplace(vars[[i]], vars[ seq_len( i - 1L) ])

    vars
}

langReplace =
    #
    # recursively replace symbols in x with the corresponding value from the list `what`
    #
function(x, what)    
{
    if(is.atomic(x))
        return(x)
    
    if(is.symbol(x)) {
        m <- match(as.character(x), names(what))
        return(if(!is.na(m))
                   what[[m]]
               else
                   x)
    }
        
    # recursively process any language objects that are not symbols.
    w = sapply(x, is.symbol)
    wl = sapply(x, is.language)
    w2 = wl & !w
    if(any(w2))
        x[w2] = lapply(x[w2], langReplace, what)

    # replace the symbols.
    if(any(w)) {
        v = x[w]
        v = sapply(v, as.character)
        m = match(v, names(what), 0)
        x[w][m != 0] = what[ m ]
    }
    
    x
}


#
#
replaceConstants =
function(code, cons)    
{
    idx = indexWalkCode(code, isConstRef)
    if(length(idx)) {
        for(i in idx) {
            #XXX could have  constant!xxx[constant!yyy] and end up replacing in wrong order.
           code = replaceConstant(i, code, cons)
        }
    }
    
    code
}

replaceConstant =
function(idx, code, cons)    
{
    p = getParent(idx, code)
    if(isCallTo(p, "[")) {
        e = p
        idx = idx[-length(idx)]
    } else
        e = code[[idx]]

    val = mapConsValue(code[[idx]], cons)

    insertByIndex(val, idx, code)
    
}

isConstRef =
function(x, ...)   
  is.symbol(x) && grepl("^constant!", as.character(x))
