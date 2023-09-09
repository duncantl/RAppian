findCalls =
function(file = "code.eg", 
         domain = "a!",
         pattern = paste0(domain, "[^\\[(),*:[:space:]]+"),
         k = paste(readLines(file, warn = FALSE), collapse = "\n"))
{
    if(!file.exists(file)) #  && grepl('localVariable', file))
        k = file
    
    regmatches(k, gregexpr(pattern, k)) # [[1]]
}

getDomains =
function(...)
{
  findCalls(...,  pattern =  "[A-Za-z0-9]+!")
}


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

