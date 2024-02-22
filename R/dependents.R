getAllDependents =
function(id, map = mkSummary(), names = FALSE)
{
    i = match(id, map$name)
    if(is.na(i)) 
        i = match(id, map$uuid)

    if(is.na(i))
        stop("didn't match ", id, " to a name or UUID in the map")

    u = map$uuid[i]
    w = sapply(map$file, xmlContains, u)
    if(names)
        map$name[w]
    else
        map[w,]
}

xmlContains =
    #
    # Check for the text what in any text() node or any attribute.
    #
function(doc, what)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    length(getNodeSet(doc,
                sprintf("//text()[contains(., '%s')] | //@*[contains(., '%s')]", what, what))) > 0
}



