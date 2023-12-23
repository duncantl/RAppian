dir = "~/OGS/EForms/CodeReview/GM1/"
source("basics.R")
map2 = mkSummary("~/OGS/EForms/CodeReview/EFormsDec13")
map3 = rbind(map[, names(map2)], map2)

f = saveTo(rcode2$GM1_legacyHandler_submit)
u = saveTo(rcode2$GM1_studentDetails)


sapply(u, function(x) rewriteCode(x [ names(x) %in% c("saveInto", "selectSaveInto")], map3))

# Any expliciti a!save() calls.
sapply(u, function(x) is.call(x) && isSymbol(x[[1]], "a!save"))

# None for studentDetails either.
