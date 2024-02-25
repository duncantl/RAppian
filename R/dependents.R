getAllDependents =
function(id, map = mkSummary(), names = FALSE, code = FALSE)
{
    i = match(id, map$name)
    if(is.na(i)) 
        i = match(id, map$uuid)

    if(is.na(i)) {
        # If id is a UUID, it could be a field in a record type so don't
        # complain about that. Otherwise, if it is not a UUID, we didn't find it.
        if(!isUUID(id))
            stop("didn't match ", id, " to a name in the map")
        else
            u = id
    } else
        u = map$uuid[i]

    w = sapply(map$file, xmlContains, u, code = code)

    if(!code) {
        if(names)
            map$name[w]
        else
            map[w,]
    } else {
        names(w) = map$name
        w[sapply(w, length) > 0]
    }
}

xmlContains =
    #
    # Check for the text what in any text() node or any attribute.
    #
function(doc, what, code = FALSE)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    els = getNodeSet(doc,
                     sprintf("//text()[contains(., '%s')]/.. | //@*[contains(., '%s')]/..", what, what))

    if(!code)
        length(els) > 0
    else
        els
}





