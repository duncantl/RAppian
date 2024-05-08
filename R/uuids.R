# From Wikipedia https://en.wikipedia.org/wiki/Universally_unique_identifier
# Usual format is 8-4-4-4-12
uuidRX0 = '#"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"'
uuidRX2 = '#"(_a-)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(_[0-9]+)?"'

# No # or "'s
uuidRX3 = '(_a-)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(_[0-9]+)?'

isUUID =
function(x)
    grepl(uuidRX3, x)

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
function(x, map = mkSummary(...), ..., col = "qname", paths = TRUE)
{
    hasQ = grepl("\\?", x)
    ques = gsub(".*\\?", "", x[hasQ])

    x = gsub("\\?.*", "", x)
    
    w = grepl('^#urn:', x)
    if(any(w)) 
        x[w] = resolveURN(x[w], map, col = col, paths = paths)
 
    w = grepl('^#', x)
    if(any(w)) {
        uuid = gsub('(^"|"$)', '', substring(x[w], 2))

        x[w] = mapUUID(uuid, map$uuid, map[[col]])
    }

    w = grepl("^SYSTEM_SYSRULES_", x)
    if(any(w))
       x[w] = gsub("^SYSTEM_SYSRULES_(.*)(_v1)?", "a!\\1", x[w])

    if(any(hasQ))
        x[hasQ] = paste(x[hasQ], ques, sep = "?")
    x
}

mapUUID =
    #
    #
    #
function(uuid, uuids, out = "name")
{
    if(is.data.frame(uuids) && "uuid" %in% names(uuids)) {
        if(length(out) == 1)
            out = uuids[[ out ]]
        uuids = uuids$uuid
    }

    hasQ = grep("\\?", uuid)
    suffix = gsub(".*\\?", "?", uuid[hasQ])
    
    uuid = gsub("\\?.*", "", uuid)
    
    m = match(uuid, uuids)
        
    # check for NAs
    ans = out[m]
    if(any(hasQ))
        ans[hasQ] = paste0(out[m][hasQ], suffix)

    ans
}


fixURN =
    #
    # For cases where we have URNs of the form =#"....".
    #
function(x)
{
    gsub( '"$', "", gsub('^=#"urn', "#urn", x))
}


resolveURN =
    # The urn:appian:<type>:v1 we see are 
    #  record-field (1623)
    #  record-type  (145)
    #  record-relationship (9)
    #  function  (5)
    #
    
    # The record-field and record-relationships are multi-part (contain a /)
    # The record-type and function are not multipart.
    #
    # Now taking a long time - 12 seconds for 1623 urns:
    # Got this down to .026 seconds by only processing the unique URNs
    # and then returning corresponding values.
    #
    #  urns = grep("urn:", asyms, value = TRUE)
    #  gurns = split(urns, gsub("^#+urn:appian:([^:]+):v1:.*", "\\1", urns))
    #  system.time(resolveURN(gurns$"record-field", map))
    #
    # Still doing more work than needed
    # + √ reading XML files for recordTypeInfo which we have in map
    # + √ could read the recordTypeRelationships once and put in map/mkSummary() result and use from there.
    # + √ could get all elements in all URNs and resolve them all once and then use across all (unique) urns.
    #
function(x, map, col = "qname", paths = TRUE)
{
    x = fixURN(x)
    type = urnType(x)
    
    tmp = gsub("^#urn:.*:v1:", "", x)

    # Has 2 or more parts?
    multipart = grepl("/", tmp)
    ans = character(length(tmp))

    # resolve the first/only part
    # XXX don't do this for the multipart[!isrel] as we do resolve
    # the first element there, but not a big deal for now.
    ans[!multipart] = mapUUID(tmp[!multipart], map$uuid, map[[col]])

    if(any(multipart)) {
        murn = resolveMultiURN(tmp[multipart], map)
        #XXX clean this up.
        if(sum(multipart) == 1 && is.character(murn))
            murn = list(murn)

        ans[multipart] = if(!paths)
                             sapply(murn, function(x) x[length(x)])
                         else
                             sapply(murn, paste, collapse = " -> ")
    }

    w = type == "function"
    ans[ w ] = gsub(":", "!", tmp[w])

    ans
}


resolveMultiURN =
    #
    # handle record-relationships and sequence of 2, 3 and 4 UUIDs identifying the connections
    # across record types/tables.
    #
function(x, map, col = "qname")
{
    if(length(x) > 1) {
        ux = unique(x)
        tmp = lapply(ux, resolveMultiURN, map, col)
        return(structure(tmp[ match(x, ux) ], names = x))
    }
    
    tmp = gsub("^#urn:.*:v1:", "", x)
    els = strsplit(tmp, "/")[[1]]
    ans = mapUUID(els[1], map$uuid, map$name) # map[[col]])

    i = 1L
    idx = 2L
    w =  els[i] == map$uuid 
    file = map$file[w]
    if(length(file) == 0)
        return(as.character(rep(NA, length(els))))
    
    rt = map$recordType[[ which(w) ]]
    rr = map$recordRelationships [[ which(w) ]] # recordTypeRelationships(file)
    nm = map$name[ w ] # getName(file)

    while(idx <= length(els)) {
        # get the record-type and the record relationships from the UUID file.
        w = rr$uuid == els[idx]
        if(any(w)) {
            rel = rr[w,]
            # append the source field name onto the record type on the previous element of ans.
            if(!grepl(".", ans[length(ans)], fixed = TRUE))
                ans[length(ans)] = paste(ans[length(ans)], rt$fieldName[rt$uuid == rel$sourceField], sep = ".")

            w = map$uuid == rel$targetRecordType
            file = map$file[ w ]
            if(length(file) == 0)
                return(c(ans, rep(NA, length(els) - length(ans) - 1)))
            
            # rt = recordTypeInfo(file)
            rt = map$recordType[[ which(w) ]]
            fn2 = rt$fieldName[rel$targetField == rt$uuid]
            nm = map$name[w] # getName(file)            
            ans = c(ans, paste(nm, fn2, sep = "."))
            rr = map$recordRelationships[[ which(w) ]]  # recordTypeRelationships(file)

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

