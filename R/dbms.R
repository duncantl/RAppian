readDBDump =
function(file = mostRecent("127_0_0_1.*\\.json$", dir), dir = ".")
{
    j = RJSONIO::fromJSON(file)
    w = sapply(j, `[[`, "type") == "table"
    structure(lapply(j[w], mkDBTable), names = sapply(j[w], `[[`, "name"))
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
