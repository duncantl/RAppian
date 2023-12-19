library(RAppian)
library(XML)

if(!exists("dir", globalenv(), inherits = FALSE))
   stop("dir must be defined")

#appDir = "~/OGS/EForms/RAppian/R"
#invisible(lapply(list.files(appDir, pattern = "\\.R$", full = TRUE), source))
# was just exploreCode.R and xmlFuns.R

con.files = list.files(file.path(dir, "content"), pattern = "\\.xml$", full.names = TRUE)
# file.path("content", paste0(con.uuids, ".xml"))
nm = sapply(con.files, function(x) names(xmlRoot(xmlParse(x))[2]))
showCounts(dsort(table(nm)))

# Look at the code in the rule and interface objects.
# See allSAILCode.R and whereSAILCode.R for additional types and XML nodes that may contain SAIL code.
hasCode = nm %in% c("rule", "interface")
defs = sapply(con.files[hasCode], getDefinition)
names(defs) = sapply(con.files[hasCode], getName)


# Do we want to work from actual R language objects representing the SAIL code and
# get the domains from these rather than regular expressions.
showCounts(dsort(table(unlist(lapply(defs, RAppian:::getDomains)))))

# Do we want findCalls or findCallsTo and process those?
showCounts(dsort(table(unlist(lapply(defs, RAppian:::findCalls)))))


####
# Constants

cons = do.call(rbind, lapply(con.files[ nm == "constant" ], getConstantInfo))

showCounts(dsort(table(cons$type)))


#########
# app = xmlParse(list.files("application", full = TRUE))
# con.uuids = xpathSApply(app, "//application//associatedObjects//item[./type = 'content']/uuids/uuid", xmlValue)

ff = list.files(file.path(dir, "content"), full.names = TRUE)
ff2 = lapply(ff[file.info(ff)$isdir], list.files)
table(sapply(ff2, length))
showCounts(dsort(table(unlist(ff2))))
