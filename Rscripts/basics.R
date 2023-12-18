library(CodeAnalysis)
library(RAppian)
library(RJSONIO)
# invisible(lapply(list.files("~/OGS/EForms/RAppian/R", full = TRUE, pattern = "\\.R$"), source))

if(!exists("dir", inherits = FALSE)) {
    if(file.exists("META-INF"))
        dir = "."
    else
        dir = "~/OGS/EForms/CodeReview/EFormsDec13"
}


#umap = mkUUIDMap(dir)
map = mkSummary(dir)

if(file.exists("~/OGS/EForms/CodeReview/CMN")) 
    map = rbind(map, mkSummary("~/OGS/EForms/CodeReview/CMN"))

map$code = sapply(map$file, getCode)
map$LOC = sapply(strsplit(map$code, "\n"), length)
code = mkCodeInfo(dir)
rcode = lapply(code$code, function(x) try(StoR(x, TRUE)))
names(rcode) = code$name
rcode2 = lapply(rcode, function(x) try(rewriteCode(x, map)))
err = sapply(rcode2, inherits, 'try-error')
stopifnot(!any(err))
