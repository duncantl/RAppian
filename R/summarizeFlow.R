if(FALSE) {

aa = data.frame(nodeName = co$name,
                outVar = sapply(co$code, function(x) as.character(x[[2]])),
                fun = sapply(co$code, function(x) if(is.call(x[[3]])) as.character(x[[3]][[1]]) else as.character(x[[3]])))

}


summarizeProcModel =
    #
    # Figure out which interface is the starting one.
    # Get the code for the interface
    #
function(name, map = mkSummary())
{
    ff = mapFile(name, map)

    co = customOutputs(ff)
    structure(list(nodes = procModelNodes(ff),
                   processVars = procVars(ff),
                   interfaceInfo = interfaceInfo(ff.atc, map),
                   customOutputs = co,
                   outputVarFuns = outputInfo(co),
                   file = ff
                   ), class = "ProcessModelInfo")
}

mapFile =
function(name, map)    
{
    w = map$name == name
    if(!any(w))
        stop("no element in map with name ", name)
    
    ff = map$file[w]
    if(map$type[w] == "constant")
        ff = uuid2File(getConstantInfo(ff)$value)

    ff
}


outputInfo =
function(co)    
{
    data.frame(nodeName = co$name,
               outVar = sapply(co$code, mkOutVar, map),
               fun = sapply(co$code, function(x) if(is.call(x[[3]]))
                                                     as.character(x[[3]][[1]])
                                                 else
                                                     as.character(x[[3]])))
}

mkOutVar =
function(x, map)
{
    e = x[[2]]
    if(is.name(e))
        return(as.character(e))
    
    if(!is.call(e))
        stop("expected a call, got ", class(e))

    k = e[[1]]
    if(!is.name(k))
        stop("still not sure what to do with", deparse(k))

    if(as.character(k) == "[") 
        return(paste(as.character(e[[2]]),
                     gsub(".*\\.", "", resolveURN(as.character(e[[3]]), map, "name", paths = FALSE)),
                     sep = "."))


    return("???")
    
}
