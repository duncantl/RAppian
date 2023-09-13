library(RAppian)

library(CodeAnalysis)

dir = "."
code = mkCodeInfo(dir)
rcode = lapply(code$code, StoR, TRUE)
names(rcode) = code$name

map = mkSummary()
#umap = mkUUIDMap(dir)

# Assumes names, not calls, but should be good for SAIL. Or did I see one expression in there?
funs = lapply(rcode, function(x) sapply(findCallsTo(x), function(x) as.character(x[[1]])))

funs2 = lapply(funs, mapName, map)
showCounts(dsort(table(unlist(funs2))))


# Get all the symbols in all of the functions and then resolve the
# UUIDs, urns, etc.
rsyms = lapply(rcode, CodeAnalysis:::all_symbols)

if(FALSE) {
    # some of the syms map to the same name so setting the names on tt and using showCounts() (which creates a data.frame)
    # raises an error about duplicate names.

    tt = table(unlist(rsyms))
    m2 = mapName(names(tt) , map)    
    names(tt) = m2
    showCounts(dsort(tt))
}

table(duplicated(m2))
asyms = unlist(rsyms)
masyms = structure(mapName(unique(asyms), map), names = unique(asyms))
tt = table(masyms[asyms])
showCounts(dsort(tt))
