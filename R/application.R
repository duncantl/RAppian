appItems =
function(doc)
{
    doc = mkDoc(doc)
    it = getNodeSet(doc, "//item[./uuids/uuid]")
    if(length(it) == 0)
        return(list())
    
    ans = lapply(it, function(x)  xmlSApply(x[["uuids"]], xmlValue))
    names(ans) = sapply(it, function(x) xmlValue(x[["type"]]))
    
    ans
}
