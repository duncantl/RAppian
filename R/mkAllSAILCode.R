if(FALSE) {
    # from Rscripts/basics.R, get map and rcode2
    # Then add the information from the site, record type and process model to the call graph.
    z = mkAllCode(map, rcode2)
}



mkAllCode =
    #
    # Add the site, process model and record type uses of functions in the applications
    # to the call graph g.
    #
function(map, rcode2, g = callGraph(map$name, rcode, TRUE))
{
    ty = (map$type == "processModel")
    g2 = do.call(rbind, lapply(map$file[ty], mkPMCallGraph, map, rcode2))
    g = rbind(g, g2)

    ty = (map$type == "recordType")
    tmp = lapply(map$file[ty], mkRecordTypeCallGraph, map, rcode2)
    g = rbind(g, do.call(rbind, tmp))

    # site
    ty = (map$type == "site")
    si = lapply(map$file[ty], siteInfoCallGraph, map, rcode2)
    g = rbind(g, do.call(rbind, si))    
}


mkPMCallGraph =
function(file, map, rcode2, name = getName(file))
{
    fun = mkUsesFun2(names(rcode2))
    tmp = procModelUses(file, map, fun)
    tmp = rep(names(tmp), tmp)
    g2 = data.frame(calls = rep(name, length(tmp)), called = tmp)

    # start form 
    sf = startForm(file, map)
    if(length(sf) > 0)
        rbind(g2, data.frame(calls = name, called = sf))
    else
        g2
}


mkRecordTypeCallGraph =
function(file, map, rcode2, name = getName(file) )
{
    code = getRecordTypeCode(file, map)
    mkCallGraph(code, map, name)
}

mkCallGraph =
function(code, map, name)
{
    k = unlist(lapply(code, findCallsTo), recursive = FALSE)
    tmp = sapply(k, function(x) deparse(x[[1]]))
    tmp = gsub("^(rule|interface)!", "", tmp)
    tmp2 = tmp[ tmp %in% map$name ]
    data.frame(calls = rep(name, length(tmp2)),
               called = tmp2)    
}

siteInfoCallGraph =
function(file, map, rcode2, name = getName(file) )
{
    si = siteInfo(file)

    code = lapply(si$visibility, function(x) tryCatch(rewriteCode(x, map), error = function(err) quote({})))
    g = mkCallGraph(code, map, name)
    
    rbind(g,
          data.frame(calls = rep(name, nrow(si)),
                     called = si$name))
}

