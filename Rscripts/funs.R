source("basics.R")

# Assumes names, not calls, but should be good for SAIL. Or did I see one expression in there?
funs = lapply(rcode2, function(x) sapply(findCallsTo(x), function(x) as.character(x[[1]])))
syms = lapply(rcode2, all_symbols)
#funs2 = lapply(funs, mapName, map)

tmp2 = mkCountDfs(map, syms)

ff = list.files("processModel", full.names = TRUE)
tmp2[["Record Types in Process Models"]] = table2df(dsort(table(unlist(lapply(ff, getPMWriteTypes, map)))))


pm.uses = lapply(ff, procModelUses, map)
names(pm.uses) = sapply(ff, getName)
a = Reduce(mergeCounts, pm.uses)


writexl::write_xlsx(tmp2, "EFormsUsageCounts.xlsx")

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
# BAD PLOT
plot(g, margin = rep(0.1, 4), vertex.shape = "none", vertex.label.cex = 0, edge.arrow.mode = 0, layout = layout.drl)
#plot(g, vertex.label.cex = 0, edge.arrow.mode = 0)



#######################


# Constants
k = getConstants(map)
dsort(table(k$type))

k$value[k$type == "string"]

k$value[k$type == "Text?list"]


# Find folders.
#XXX fails in Sep 22 version - Exported_4
folders = getFolders(dir)
table(folders)
table(dirname(names(folders)[is.na(folders)]))
xml = xmlFiles(dir)
folders = sapply(xml, getFolder)
names(folders) = xml



# Comments in the SAIL code
# Looking for large blocks commented out.
com = findComments(code$code)
table(sapply(com, length))
table(nchar(unlist(com)))

sapply(com, function(x) any(nchar(x) > 100))
# Or look for sail code in the comment



#XXXX specify correct directory
db = readDBDump(dir = "~/OGS/EForms/CodeReview/DBDumps")
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
# Fails So don't use
# map$codeUses = getCodeUses(map, map$code)



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
ff = list.files(file.path(dir, "processModel"), full = TRUE)
pms = structure(lapply(ff, procModelNodes, map), names = unname(sapply(ff, getName)))

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

# what does procName get?
pname = sapply(ff, RAppian:::procName)  
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

customParams(file.path(dir, "processModel/0002eab7-e965-8000-03e1-7f0000014e7a.xml"))


# interfaceInformation objects in process models
int = lapply(ff, interfaceInfo, map)
names(int) = sapply(ff, getName)
w = sapply(int, length) > 0 
table( w )
# 8 don't have interfaceInformatio
# 24 do.

table(sapply(int, length))
# 6 have 2

table(unlist(lapply(int[w], function(x) sapply(x, `[[`, "name"))))



#####

v = saveTo(rcode2$EFRM_FORM_qeApplication)



######
# Find literal values that perhaps should be constants.
# Did this somewhere else also.
#

# Don't worry about logical values - true/false should show up in the SAIL code.

# Also, many string literals can be arguments to layout functions such as
# "COLLAPSED", ...
# But others are duplicates, e.g.,  "Upload Resume for External"

# Probably want to exclude character literal if 2nd argument to index().
#
#  "mm/dd/yyyy" in 46 different locations.  Should  be a constant.
#  "Please enter Student Email to retrieve student details."
#  "Please enter Student ID to retrieve student details."
#  "Please submit in one of the allowed format -"
#      + note error  - should be format*s* so we do have to correct this in 7 places because not a constant.
#  "Not all students will be enrolled in a Designated Emphasis. If the information displayed here is incorrect, contact your Graduate Program Coordinator."
#   "Designated Emphasis Application"
# "Yes", "No" in {} of choice labels in about 74 places.

library(rstatic) #XXX
literals = lapply(rcode2, function(x) find_nodes(to_ast(x), function(x) inherits(x, c("Numeric", "Integer", "Character"))))
z = unlist(literals, recursive = FALSE)
lit.class = sapply(z, function(x) class(x)[1])
table(lit.class)

#lit.vals = sapply(z, function(x) x$value)
lit.vals = tapply(z, lit.class, function(x) sapply(x, function(x) x$value))
sapply(lit.vals, function(x) length(unique(x)))

tt = showCounts(dsort(table(lit.vals$Character)))
head(tt, 50)


# Do this and remove the literals in calls to index()

chars = lapply(rcode2, function(x) find_nodes(to_ast(x), inherits, "Character"))
chars = unlist(chars, recursive = FALSE)
w = !sapply(chars, function(e)
                    (inherits(e$parent, "ArgumentList") && is_symbol(e$parent$parent$fn, "index")))

lit.chars = sapply(chars[w], function(x) x$value)

ok = grepl("(^[A-Z]+$)|^#|^AND$", lit.chars) | lit.chars == ""

tt.char = showCounts(dsort(table(lit.chars[!ok])))
head(tt.char[tt.char[,1] > 5, , drop = FALSE], 30)



###
isnum = sapply(z, inherits, "Numeric")
num = z[ isnum ]
num.vals = sapply(num, function(x) x$value)
w = num.vals == 30



#########
# Reuse and calls/includes

# Interfaces first
w = map$type == "interface"
ind = usedBy(rcode2[w])

nuses = colSums(ind)
table(nuses)
nn = data.frame(interface = names(nuses), numUses = nuses, row.names = NULL)

nn$description = lapply(names(nuses), function(x) getDescription(mapFile(x, map)))
nn.ri = lapply(names(nuses), function(x) ruleInputs(mapFile(x, map)))
nn$numRuleInputs = sapply(nn.ri, function(x) if(length(x) == 0) 0L else nrow(x))

tmp = nn[order(nn$numUses, decreasing = TRUE), ]
tmp[tmp$numUses > 1, c("interface", "numUses", "numRuleInputs")]


ind.ru = usedBy(rcode2[ map$type == "rule"], "rule")
# VT_checkNullOrEmpty
which.max(colSums(ind.ru))


# incidence matrix for all code objects

ind.all = usedBy(rcode2, fun = mkUsesFun2(names(rcode2)))
nuses.all = colSums(ind.all)

tmp = data.frame(name = names(rcode2), numUses = nuses.all, type = map$type)

table(tmp$type[tmp$numUses > 1])

tmp.inf = tmp[ tmp$type == "interface" & tmp$numUses > 1,]
tmp.inf[order(tmp.inf$numUses, decreasing = TRUE),  c("name", "numUses")]

rownames(ind.all)[ ind.all[, "EFRM_GRID_COMMON_ActionHistory"] > 0]
