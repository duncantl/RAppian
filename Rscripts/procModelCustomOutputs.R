library(RAppian)
ff = list.files("processModel", pattern = "\\.xml$", full = TRUE)
ids = sapply(ff, getName)
map = mkSummary()
pm = summarizeProcModel(ff[2], map)

u = pm$nodes$uuid[pm$nodes$label == "Construct Data"]

cvs = pm$customOutputs[pm$customOutputs$uuid == u, ]




