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

    #    if(any(ww <- grepl("record-relationship", x)))    browser()
    
    multipart = grepl("/", tmp)

    a = tmp
    a[multipart] = gsub("/.*", "", a[multipart])

    ans = mapUUID(a, map$uuid, map[[col]])

    b = gsub("[^/]+/", "", tmp[multipart])

    isrel = grepl("record-relationship", x[multipart])
    m = match(a[multipart], map$uuid)


    fn = character(length(b))
    if(any(!isrel)) {
        fn[!isrel] = mapply(function(fieldu, type) {
            type$fieldName[ match(fieldu, type$uuid) ]
        },  b[!isrel], map$recordType[m][!isrel])
    }
    

    if(any(isrel)) {
        rrs = lapply(structure(map$file[unique(m[isrel])], names = unique(a[multipart][isrel])),
                     recordTypeRelationships)
        
        p = a[multipart][isrel]

        fn[isrel] = mapply(function(fieldu, rr) {
            i = match(fieldu, rr$uuid)
            j = which(rr$targetRecordType[i] == map$uuid)

            trt = map$recordType[[ j ]]
            k = match(rr$targetField[i], trt$uuid)
            trt$fieldName[k]
        }, b[isrel],  rrs[p]) # , p)
    }
    
    
    ans[multipart] = paste(ans[multipart], fn, sep = ".")
    
    ans
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

