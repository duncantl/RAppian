if(FALSE) {

aa = data.frame(nodeName = co$name,
                outVar = sapply(co$code, function(x) as.character(x[[2]])),
                fun = sapply(co$code, function(x)
                                        if(is.call(x[[3]]))
                                            as.character(x[[3]][[1]])
                                        else
                                            as.character(x[[3]])))

}


summarizeProcModel =
    #
    # Figure out which interface is the starting one.
    # Get the code for the interface
    #
function(name, map = mkSummary())
{
    ff = mapFile(name, map)

    ff = mkDoc(ff)
    
    co = customOutputs(ff)
    structure(list(nodes = procModelNodes(ff),
                   processVars = procVars(ff),
                   interfaceInfo = interfaceInfo(ff, map),
                   customOutputs = co,
                   outputVarFuns = outputInfo(co, map),
                   dynamicName = procName(ff),
                   name = getName(ff),
                   file = ff
                   ), class = "ProcessModelInfo")
}

mapFile =
function(name, map)    
{
    if(file.exists(name))
        return(name)
    
    w = map$name == name
    if(!any(w)) {
        if(grepl("/", name)) {
            # check for processModel/<uuid>.xml and match the uuid.
            # Shouldn't need this now since file.exists() at top.
            # 
            u = gsub("\\.xml$", "", basename(name))
            if(isUUID(u))
                w = (u == map$uuid)
        }

        if(!any(w))
            stop("no element in map with name ", name)
    }
    

    ff = map$file[w]
    if(map$type[w] == "constant")
        ff = uuid2File(getConstantInfo(ff)$value)

    ff
}


outputInfo =
function(co, map)    
{
    data.frame(nodeName = co$nodeName,
               outVar = sapply(co$code, mkOutVar, map),
               fun = sapply(co$code, mkOutFun, map))
}

mkOutFun =
function(x, map)
{
   ans = if(is.call(x[[3]]))
             as.character(x[[3]][[1]])
         else
             as.character(x[[3]])
   if(grepl("^#", ans))
       mapName(ans, map)
   else {
       if(ans == "[") {
           ans = mapFieldAccessor(x[[3]], map)
       }
       ans
   }
   
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
        return(mapFieldAccessor(e, map))


    return("???")
}

mapFieldAccessor =
function(e, map)
{
    paste(as.character(e[[2]]),
          gsub(".*\\.", "", resolveURN(as.character(e[[3]]), map, "name", paths = FALSE)),
          sep = ".")
}

       
