#
# Examine all the XML documents and all their nodes and attributes to find
# the UUIDs of the objects in the Appian application.
#
# Need dir and map


if(FALSE) {
    library(RAppian)
    library(XML)
    
    xml = xmlFiles(dir)
    docs = lapply(xml, xmlParse)
    names(docs) = sapply(docs, getName)

    u = map$uuid [map$type == "interface"]
    z2 = findNodesContainingUUID(u, docs)
    table(unlist(lapply(z2, function(x) sapply(x, function(x) sapply(x, xmlName)))))
# definition expression     uiExpr   uiObject       uuid 
#        275         30          3          3        316     


    # This takes a long time - looping over all uuid values and all XML docs for that uuid.
    z3 = findNodesContainingUUID(map$uuid, docs)
    names(z3) = map$uuid
    
    table(sapply(unlist(z3), xmlName))

    # For each object type, find the elements in which the associated UUID occur.
    tapply(z3, map$type, function(x) table(sapply(unlist(x), xmlName)))
}

findNodesContainingUUID =
function(u, docs)
{
    z = lapply(u, function(uuid)
                    lapply(docs, function(d)
                        getNodeSet(d, sprintf("//text()[contains(., '%s')]/.. | //@*[contains(., '%s')]/..", uuid, uuid))))

    nms = sapply(docs, getName)
    z = lapply(z, function(x){ names(x) = nms; x})

    z2 = lapply(z, function(x) x [ sapply(x, length) > 0])
}


