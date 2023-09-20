library(CodeAnalysis)
library(RAppian)
library(RJSONIO)
invisible(lapply(list.files("~/OGS/EForms/RAppian/R", full = TRUE, pattern = "\\.R$"), source))

dir = "."
#umap = mkUUIDMap(dir)
map = mkSummary()
map$code = sapply(map$file, getCode)
code = mkCodeInfo(dir)
rcode = lapply(code$code, function(x) try(StoR(x, TRUE)))
names(rcode) = code$name
rcode2 = lapply(rcode, function(x) try(rewriteCode(x, map)))
err = sapply(rcode2, inherits, 'try-error')
stopifnot(!any(err))



# Assumes names, not calls, but should be good for SAIL. Or did I see one expression in there?
funs = lapply(rcode2, function(x) sapply(findCallsTo(x), function(x) as.character(x[[1]])))

#funs2 = lapply(funs, mapName, map)
tt = dsort(table(unlist(funs)))
showCounts(tt)

# Get all the symbols in all of the functions and then resolve the
# UUIDs, urns, etc.
# Can use rcode2, but not getting same answers - big differences
rsyms = lapply(rcode, ruses)

if(FALSE) {
    # some of the syms map to the same name so setting the names on tt and using showCounts() (which creates a data.frame)
    # raises an error about duplicate names.

    tt = table(unlist(rsyms))
    m2 = mapName(names(tt) , map)
    table(duplicated(m2))
    # 12 duplicated and these are NA and "NA -> NA"
    names(tt) = m2
    showCounts(dsort(tt))
}

#
asyms = unlist(rsyms)
masyms = structure(mapName(unique(asyms), map), names = unique(asyms))
tt = table(masyms[asyms])
showCounts(dsort(tt))



calls = lapply(rcode2, function(x) getGlobals(x)$functions)
calls = calls[ sapply(calls, length) > 0]

tt = table(unlist(calls))
showCounts(dsort(tt))
omit = c("(", ">", "<", "$", "<=", ">=", "==", "&", "[", "-", "+", ":")

sysFuns = setdiff(names(tt)[ (grepl("^a!", names(tt)) | !grepl("!", names(tt))) & !grepl("^#", names(tt))], omit)

ldefs = names(tt) %in% map$name



library(igraph)
calls2 = lapply(calls, function(x) { x = gsub("^(rule|interface|recordType)!", "", x); gsub("^EFRM_([A-Z]+_)?", "", unique(x[ x %in% map$name ])) })
m = cbind( rep(names(calls2), sapply(calls2, length)), unlist(calls2))
g = igraph::graph_from_edgelist(m)
plot(g, margin = rep(0.1, 4), vertex.shape = "none", vertex.label.cex = 0, edge.arrow.mode = 0, layout = layout.drl)
#plot(g, vertex.label.cex = 0, edge.arrow.mode = 0)



#######################


# Constants
k = getConstants(map)
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

# look at the code for each object and see what other objects in the application
# that each of these SAIL code expressions uses.
map$code = sapply(map$file, getCode)
#XXX!!!!  not clear if we want this still.
# Should we use ruses() and rcode2?
map$codeUses = getCodeUses(map, map$code)



if(FALSE) {
# This is uses from the entire XML file, not just the code.
map$uses = lapply(map$file, uses, toplevel = map$uuid)
map$uses2 = lapply(map$uses, function(x) unique(map$name[ match(x, map$uuid) ]))
i = which(map$type == "application")
map$uses[[i]] = map$uses2[[i]] = character()


library(igraph)
m = cbind( rep(map$name, sapply(map$uses2, length)), unlist(map$uses2))
g = igraph::graph_from_edgelist(m)
plot(g, vertex.label.cex = 0, edge.arrow.mode = 0)
}




#####
ff = list.files("processModel", full = TRUE)
pms = structure(lapply(ff, procModelNodes), names = unname(sapply(ff, getName)))

# duplicated names
sapply(pms, function(x) sum(duplicated(x$label)))

# Number of nodes
sapply(pms, nrow)

# node types
showCounts(dsort(table(do.call(rbind, pms)$icon)))

#                       count
#Write Record             179
#Script Task              141
#XOR                      120
#Subprocess                66
#End Event                 46
#End Node                  32
#AND                       16
#Generate Word Document     7
#Interface                  7
#Delete Word Document       5
#Send E-Mail                1



# identify sub-processes

sub = unique(file.path("processModel", unlist(lapply(pms, function(x) x$uuid[x$icon == "Subprocess"]))))



# process variables that are
# required but undefined
#   need to see how each process model is called
# 
# Is dynamic name

pname = sapply(ff, procName)
#literal = grepl('^=?"[^"]+"$', pname)
#pcode = lapply(gsub("^=", "", pname[!literal]), function(x) try(rewriteCode(StoR(x, TRUE), map), silent = TRUE))

pcode = lapply(gsub("^=", "", pname), function(x) try(rewriteCode(StoR(x, TRUE), map), silent = TRUE))
names(pcode) = names(pname)
err = sapply(pcode, inherits, 'try-error')
pname[err]
data.frame(name = pname[err], file = names(pname)[err], row.names = NULL)


#                                      name                                                  file
#1 ="EFRM Initiate & Submit QE Application" processModel/0002ea7f-720f-8000-fc2f-7f0000014e7a.xml
#2                       EFRM Reassign Task processModel/0002eaa4-7848-8000-005f-7f0000014e7a.xml
#3    EFRM Phd Exam Report Upload to Banner processModel/0008eabb-8b17-8000-0471-7f0000014e7a.xml
#4             ="EFRM ATC Upload to Banner" processModel/0009eab0-2a03-8000-027b-7f0000014e7a.xml



customParams("processModel/0002eab7-e965-8000-03e1-7f0000014e7a.xml")
