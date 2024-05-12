#
# This is really mkAllSAILCallGraph rather than making the code.
#
#

if(FALSE) {
    # from Rscripts/basics.R, get map and rcode2
    # Then add the information from the site, record type and process model to the call graph.
    z = mkAllCode(map, rcode2)
}



mkAllCodeCallGraph =
    # Really the call graph.
    #
    # Add the site, process model and record type uses of functions in the applications
    # to the call graph g.
    #
function(map, rcode2, g = callGraph(map$name, rcode, TRUE), constants = TRUE)
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

    # Could find references in constants to PMs and then where those constants
    # are used.

    if(constants)
        g = rbind(g,
                  pmConstantCallGraph(map),
                  constantCallGraph(map, rcode2))

    invisible(g)
}

getPMCode =
function(doc, map)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

    ci = customInputs(doc, map)$code
    ci = ci[ sapply(ci, length) > 0 ]
    co = customOutputs(doc, map)$code
    co = co[ sapply(co, length) > 0 ]    
    c(ci, co, sapply(startForm(doc), as.name))
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


pmConstantCallGraph =
    #
    # Which constants refer to process models as a calls/called data.frame
    #
function(map, info = getConstantInfo(map))
{
    tmp = pmConstants(map, info)
    m = match(tmp$value, map$uuid)
    data.frame(calls = tmp$name,
               called = map$name[i])
}

pmConstants =
function(map, info = getConstantInfo(map))
{
    w = info$type == "ProcessModel"
    info[w,]
}


constantCallGraph =
function(map, rcode2)
{
    ty = map$type == 'constant'
    cons = map$name[ty]

    syms = lapply(rcode2, getAllSymbols, FALSE)
    syms = lapply(syms, function(x) gsub("^constant!", "", x))
    syms2 = lapply(syms, function(x) x[ x %in% cons ])

    data.frame(calls = rep(names(syms2), sapply(syms2, length)),
               called = unlist(syms2))
}
