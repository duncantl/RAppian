library(CodeAnalysis)
library(RAppian)
library(RJSONIO)
# invisible(lapply(list.files("~/OGS/EForms/RAppian/R", full = TRUE, pattern = "\\.R$"), source))

addCMN = FALSE

if(!exists("dir", inherits = FALSE)) {

    dir = getOption("AppianExport", 
    
                    if(file.exists("META-INF"))
                        dir = "."
                    else
                        dir = mostRecent("EForms", dir = "~/OGS/EForms/CodeReview")
                    )
}


#umap = mkUUIDMap(dir)
map = mkSummary(dir)

# "~/OGS/EForms/CodeReview/CMN"
# No need for CMN now that it is already part of the merged E-Forms export
if(addCMN) {
cmn.dir = mostRecent("^CMN",  normalizePath(file.path(dir, "..")))
if(length(cmn.dir)) 
    map = rbind(map, mkSummary(cmn.dir))
}

map$code = sapply(map$file, getCode)
map$LOC = sapply(strsplit(map$code, "\n"), length)
code = mkCodeInfo(dir)
rcode = lapply(code$code, function(x) try(StoR(x, TRUE)))
names(rcode) = code$name
rcode2 = lapply(rcode, function(x) try(rewriteCode(x, map)))
err = sapply(rcode2, inherits, 'try-error')
# stopifnot(!any(err))

if(any(err))
    message("problems parsing ", sum(err), " SAIL code objects")


if(any(err)) {
    # remove
    #     "CMN_ucAnyTypeArrayPickerFilter"
    # and fix up rcode2, map, err, ....
    if("CMN_ucAnyTypeArrayPickerFilter" %in% names(err)[err]) {
        id = "CMN_ucAnyTypeArrayPickerFilter"
        m = match(id, names(rcode2))
        map = map[ -m, ]
        err = err [ -m ]
        rcode2 = rcode2[ -m ]
    }
}

