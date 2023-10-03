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
