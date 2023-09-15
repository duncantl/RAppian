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
    #
    # convert a uuid in various forms to a qualified name (e.g., a!foo)
    #
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
    #
    #
    #
function(uuid, uuids, out)
{
    if(is.data.frame(uuids) && "uuid" %in% names(uuids)) {
        if(length(out) == 1)
            out = uuids[[ out ]]
        uuids = uuids$uuid
    }
    
    m = match(uuid, uuids)
        
    # check for NAs
    out[m]
}


resolveURN =
function(x, map, col = "qname")
{
    tmp = gsub("^#urn:.*:v1:", "", x)

    #    if(any(ww <- grepl("record-relationship", x)))    browser()

    # Has 2 or more parts?
    multipart = grepl("/", tmp)

    a = tmp
    # remove all but the first part.
    a[multipart] = gsub("/.*", "", a[multipart])

    # resolve the first/only part
    ans = mapUUID(a, map$uuid, map[[col]])

    if(!any(multipart))
        return(ans)
    
    # Should this be ^[^/] ??
#    b = gsub("[^/]+/", "", tmp[multipart])

    isrel = grepl("record-relationship", x[multipart])
    m = match(a[multipart], map$uuid)

    fn = character(sum(multipart)) 
    if(any(!isrel)) {
        # use ans[multipart][!isrel] as the resolved value for the first part.
        els = strsplit(tmp[multipart][!isrel], "/")
        
        fn[!isrel] = mapply(function(fieldu, type) {
            type$fieldName[ match(fieldu, type$uuid) ]
        },  b[!isrel], map$recordType[m][!isrel])
    }
    

    # process the #urn...:record-relationship:... values.
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


resolveMultiURN =
function(x, map, col = "qname")
{
    tmp = gsub("^#urn:.*:v1:", "", x)
    els = strsplit(tmp, "/")[[1]]
    ans = mapUUID(els[1], map$uuid, map$name) # map[[col]])

    i = 1L
    idx = 2L
    file = map$file[ els[i] == map$uuid ]
    rt = recordTypeInfo(file)
    rr = recordTypeRelationships(file)
    nm = getName(file)

    while(idx <= length(els)) {
        # get the record-type and the record relationships from the UUID file.
        w = rr$uuid == els[idx]
        if(any(w)) {
            rel = rr[w,]
            # append the source field name onto the record type on the previous element of ans.
            if(!grepl(".", ans[length(ans)], fixed = TRUE))
                ans[length(ans)] = paste(ans[length(ans)], rt$fieldName[rt$uuid == rel$sourceField], sep = ".")
            file2 = map$file[ map$uuid == rel$targetRecordType]
            rt2 = recordTypeInfo(file2)
            fn2 = rt2$fieldName[rel$targetField == rt2$uuid]
            ans = c(ans, paste(getName(file2), fn2, sep = "."))
            rt = rt2
            rr = recordTypeRelationships(file2)
            nm = getName(file2)
            file = file2
        } else {
            w = rt$uuid == els[idx]
            ans = c(ans, paste(nm, rt$fieldName[w], sep = "."))
        }
        

        idx = idx + 1L
    }
    
    structure(ans, class = "RecordRelationship")
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

