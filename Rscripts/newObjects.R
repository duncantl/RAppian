# Determine the new objects between two appian exports.

source("~/OGS/EForms/RAppian/Rscripts/basics.R")
omap = mkSummary("~/OGS/EForms/CodeReview/Exported_dev1")

nw = setdiff(map$name, omap$name)
nw2 = grep("^(VT|CMN|VMO|Appian|All|Default|Common)", nw, value = TRUE, invert = TRUE)
g = split(nw2, map$type[i])

# output a collection of markdown lists.
invisible(sapply(names(g), function(x) cat(c(paste("\n\n## ", x), paste("+ ", g[[x]])), sep = "\n")))
