library(CodeAnalysis)
library(RAppian)
library(RJSONIO)
invisible(lapply(list.files("~/OGS/EForms/RAppian/R", full = TRUE, pattern = "\\.R$"), source))

dir = "."
code = mkCodeInfo(dir)
rcode = lapply(code$code, function(x) try(StoR(x, TRUE)))
names(rcode) = code$name
err = sapply(rcode, inherits, 'try-error')


map = mkSummary()
#umap = mkUUIDMap(dir)

# Assumes names, not calls, but should be good for SAIL. Or did I see one expression in there?
funs = lapply(rcode, function(x) sapply(findCallsTo(x), function(x) as.character(x[[1]])))

funs2 = lapply(funs, mapName, map)
tt = dsort(table(unlist(funs2)))
showCounts(tt)

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


# Constants
k = getConstants()
dsort(table(k$type))

k$value[k$type == "string"]

k$value[k$type == "Text?list"]



# Find folders.
folders = getFolders()
table(folders)
table(dirname(names(folders)[is.na(folders)]))
xml = xmlFiles()
folders = sapply(xml, getFolder)
names(folders) = xml



# Comments in the SAIL code
# Looking for large blocks commented out.
com = findComments(code$code)
table(sapply(com, length))
table(nchar(unlist(com)))

sapply(com, function(x) any(nchar(x) > 100))
# Or look for sail code in the comment



#
db = readDBDump(dir = "..")
db = db[grep("^EFRM", names(db))]
names(db) = gsub("^EFRM_", "", names(db))
t(sapply(db, dim))




######
if(FALSE) {
top = toplevelUUIDs()
u = lapply(xml, uses, toplevel = top)
names(u) = sapply(xml, getName)
}

map$uses = lapply(map$file, uses, toplevel = map$uuid)

map$uses2 = lapply(map$uses, function(x) unique(map$name[ match(x, map$uuid) ]))

i = which(map$type == "application")
map$uses[[i]] = map$uses2[[i]] = character()


library(igraph)
m = cbind( rep(map$name, sapply(map$uses2, length)), unlist(map$uses2))
g = igraph::graph_from_edgelist(m)
plot(g, vertex.label.cex = 0, edge.arrow.mode = 0)

