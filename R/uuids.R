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
function(x, map = mkSummary(...), ..., col = "qname")
{
    w = grepl('^#urn:', x)
    if(any(w)) 
        x[w] = resolveURN(x[w], map, col = col)
 
    w = grepl('^#', x)
    if(any(w)) {
        uuid = gsub('(^"|"$)', '', substring(x[w], 2))

        x[w] = mapUUID(uuid, map$uuid, map[[col]])
    }

    w = grepl("^SYSTEM_SYSRULES_", x)
    if(any(w))
       x[w] = gsub("^SYSTEM_SYSRULES_(.*)(_v1)?", "a!\\1", x[w])
    
    x
}

mapUUID =
function(uuid, uuids, out)
{
    m = match(uuid, map$uuid)
        
    # check for NAs
    out[m]
}


resolveURN =
function(x, map, col = "qname")
{
    tmp = gsub("^#urn:.*:v1:", "", x)
    multipart = grepl("/", tmp)

    a = tmp
    a[multipart] = gsub("/.*", "", a[multipart])

    ans = mapUUID(a, map$uuid, map[[col]])

    b = gsub("[^/]+/", "", tmp[multipart])
#    browser()

    m = match(a[multipart], map$uuid)
    fn = mapply(function(f, type) {
        type$fieldName[ match(f, type$uuid) ]
    },  b, map$recordType[m])

    ans[multipart] = paste(ans[multipart], fn, sep = ".")
    
    ans
#    els = strsplit(tmp, "/")
#    sapply(els, resolveURNEls, map, col)
}

resolveURNEls =
function(x, map, col = "qname")
{
    # obj1 = mapName(x[1], map, col = col)
    mapUUID(x, map$uuid, map[[col]])
    
}

urnType =
function(x)
{
    gsub("#urn:appian:([^:]+):v.*", "\\1", x)
}

