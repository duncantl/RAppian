# Look for
#   1) in code, a!writeRecords or a!writeRecords_23_2
#   2) in process models for nodes with icon == "Write Record"
#      and for those nodes, look at the corresponding ACPs data.frame
#      for the record with name == "RecordType" and then get the code.
#      Need to remove the = and " in the string and resolve the URN
#

getPMWriteTypes =
    # expects a data.frame describing the nodes.
function(pm, map)    
{
    if(is.character(pm))
        pm = procNodes(pm, map)
    
    w = pm$icon == "Write Record"
    if(!any(w))
        return(character())

    k = sapply(pm$ACPs[w], function(x) x$code[x$name == "RecordType"])
    u = gsub('(^=|")', '', k)
    structure(resolveURN(u, map), names = u)
}

pmWriteRecords =
    #
    # This expects the result from summarizeProcModel. Now can accept the data.frame describing
    # the nodes.
    # Consolidate the two.
    # Basically the same.
    # The getPMWriteTypes includes the UUIDs as names, but keeps the recordType! prefix.
    #
function(pm, map)
{
    if(is.list(pm) && "nodes" %in% names(pm))
        pm = pm$nodes
    
    isWrite = !is.na(pm$icon) & pm$icon == "Write Record"
    if(any(isWrite)) {
        acps = pm[isWrite, "ACPs"]
        ty = sapply(acps, function(y) {
                             w = y$name == "RecordType"
                             y$code[w]
        })
        resolveURN(fixURN(ty), map)
    } else
       character()
}

