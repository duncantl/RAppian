# library(RAppian)
library(XML)
appDir = "~/OGS/EForms/RAppian/R"
invisible(lapply(list.files(appDir, pattern = "\\.R$", full = TRUE), source))
#source(file.path(appDir, "exploreCode.R"))
#source(file.path(appDir, "xmlFuns.R"))

con.files = list.files("content", pattern = "\\.xml$", full.names = TRUE)
# file.path("content", paste0(con.uuids, ".xml"))
nm = sapply(con.files, function(x) names(xmlRoot(xmlParse(x))[2]))
showCounts(dsort(table(nm)))

# Look at the code in the rule and interface objects.
# See allSAILCode.R and whereSAILCode.R for additional types and XML nodes that may contain SAIL code.
hasCode = nm %in% c("rule", "interface")
defs = sapply(con.files[hasCode], getDefinition)
names(defs) = sapply(con.files[hasCode], getName)


showCounts(dsort(table(unlist(lapply(defs, getDomains)))))

showCounts(dsort(table(unlist(lapply(defs, findCalls)))))


####
# Constants

cons = do.call(rbind, lapply(con.files[ nm == "constant" ], getConstantInfo))

showCounts(dsort(table(cons$type)))


#########
# app = xmlParse(list.files("application", full = TRUE))
# con.uuids = xpathSApply(app, "//application//associatedObjects//item[./type = 'content']/uuids/uuid", xmlValue)

ff = list.files("content", full.names = TRUE)
ff2 = lapply(ff[file.info(ff)$isdir], list.files)
table(sapply(ff2, length))
showCounts(dsort(table(unlist(ff2))))
