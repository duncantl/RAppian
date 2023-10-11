# Look for
#   1) in code, a!writeRecords or a!writeRecords_23_2
#   2) in process models for nodes with icon == "Write Record"
#      and for those nodes, look at the corresponding ACPs data.frame
#      for the record with name == "RecordType" and then get the code.
#      Need to remove the = and " in the string and resolve the URN
#

getPMWriteTypes =
function(pm, map)    
{
    if(is.character(pm))
        pm = procNodes(pm)
    
    w = pm$icon == "Write Record"
    if(!any(w))
        return(character())

    k = sapply(pm$ACPs[w], function(x) x$code[x$name == "RecordType"])
    u = gsub('(^=|")', '', k)
    structure(resolveURN(u, map), names = u)
}
