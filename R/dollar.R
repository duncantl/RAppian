if(FALSE) 
`$` =
function(x, name)
{
    v = substitute(name)
    if(is.call(x)) {
        id = deparse(substitute(name))
        w = grepl(id, names(x))
        if(any(w))
            return(x[[ which(w)[1] ]])
    }
    browser()
    # XXX get this to work.
    base::`$`(x, v)
}

