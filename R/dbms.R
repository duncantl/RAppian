readDBDump =
function(file = mostRecent("127_0_0_1.*\\.json$", dir), dir = ".", removePrefix = TRUE, efrmOnly = TRUE)
{
    j = RJSONIO::fromJSON(file)
    w = sapply(j, `[[`, "type") == "table"
    ids = sapply(j[w], `[[`, "name")
    
    if(efrmOnly) {
        w2 = grepl("^EFRM_", ids)
        i = which(w)[w2]
        ids = ids[w2]
    } else
        i = which(w)


    if(removePrefix)
        ids = gsub("^(EFRM|CMN|RWM)_", "", ids)
    
    structure(lapply(j[i], mkDBTable), names = ids)
}

mkDBTable =
function(x)
{
    a = as.data.frame(do.call(rbind, x$data))
    a[] = lapply(a, cvtDBColumn)
    a
#    sapply(a, 
}

cvtDBColumn =
function(x)    
{
    if(is.list(x)) {
        w = sapply(x, is.null)
        if(all(sapply(x[!w], class) %in% c("logical", "numeric", "integer", "character"))) {
            x[w] = NA
            x = unlist(x)
        }
    }
    
    # simplify2array(x)
    type.convert(x, as.is = TRUE)
}



mostRecent
function(pattern, dir = "~/Downloads")
{
    info = file.info(list.files(dir, pattern = pattern, full.names = TRUE))
    rownames(info)[which.max(info$ctime)]
}
