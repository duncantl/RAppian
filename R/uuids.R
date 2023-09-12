# From Wikipedia https://en.wikipedia.org/wiki/Universally_unique_identifier
# Usual format is 8-4-4-4-12
uuidRX0 = '#"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"'
uuidRX2 = '#"(_a-)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(_[0-9]+)?"'

# No # or "'s
uuidRX3 = '(_a-)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(_[0-9]+)?'

getUUIDs =
function(x, clean = TRUE)    
{
    u = regmatches(x, gregexpr(uuidRX2, x))
    if(clean)
        u = lapply(u, function(u) gsub('(^#"|"$)', "", u))

    u
}

mkUUIDMap =
    # umap = mkUUIDMap()
    # called from the ExportedApp directory
function(dir = ".", ff = list.files(dir, recursive = TRUE, full.names = TRUE))
{
    ww = grepl(uuidRX3, basename(ff))
    ff = ff[ww]
    structure(paste(sapply(ff, getDocType), sapply(ff, getName), sep = "!"),
              names = gsub("\\.xml", "", basename(ff)))
}

mapName =
function(x, map, recTypes = recordTypeList())
{
    w = grepl('^#urn:', x)
    if(any(w)) 
        x[w] = resolveURN(x[w], map)
 
    w = grepl('^#', x)
    if(any(w)) {
        uuid = gsub('(^"|"$)', '', substring(x[w], 2))
        m = match(uuid, names(map))
        
        # check for NAs
        x[ w ] = map[m]
    }

    w = grepl("^SYSTEM_SYSRULES_", x)
    if(any(w))
       x[w] = gsub("^SYSTEM_SYSRULES_(.*)(_v1)?", "a!\\1", x[w])
    
    x
}

resolveURN =
function(x, map)
{
    tmp = gsub("^#urn:.*:v1:", "", x)
    els = strsplit(tmp, "/")
    sapply(els, resolveURNEls, map)
}

resolveURNEls =
function(x, map)
{
    obj1 = mapName(x[1], map)
    
}

urnType =
function(x)
{
    gsub("#urn:appian:([^:]+):v.*", "\\1", x)
}

