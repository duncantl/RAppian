library(RAppian)

dir = "."
code = mkCodeInfo(dir)
rcode = lapply(code$code, StoR, TRUE)

map = mkSummary()
#umap = mkUUIDMap(dir)

# Assumes names, not calls, but should be good for SAIL. Or did I see one expression in there?
funs = lapply(rcode, function(x) sapply(findCallsTo(x), function(x) as.character(x[[1]])))

funs2 = lapply(funs, mapName, map)
showCounts(dsort(table(unlist(funs2))))



rsyms = lapply(rcode, CodeAnalysis:::all_symbols)
tt = table(unlist(rsyms))
u = grep("#urn", names(tt), value = TRUE)

m2 = mapName(names(tt) , map)

recTypes = recordTypeList()


