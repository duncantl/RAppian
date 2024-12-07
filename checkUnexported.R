library(CodeAnalysis)

checkUsedUnexported =
function(rscriptFiles, pkg)    
{
    if(length(rscriptFiles) == 1 && file.info(rscriptFiles)$isdir)
        rscriptFiles = CodeAnalysis:::getRFiles(rscriptFiles)
#    rf = list.files("Rscripts", full = TRUE, pattern = "\\.R$")
    re = lapply(rscriptFiles, parse)
    ref = lapply(re, function(x) getGlobals(x)$functions)
    z = intersect(unique(unlist(ref)), names(getFunctionDefs("R")))
    library(pkg, character.only = TRUE)
    sort(setdiff(z, ls(paste0("package:", pkg), all = TRUE)))
}


if(FALSE) {
    ff = list.files("Rscripts", full = TRUE, pattern = "\\.R$")
    e = lapply(ff, parse)
    k = unlist(lapply(e, CodeAnalysis::findCallsTo))
    w = sapply(k, function(x) is.name(x[[1]]) || (is.call(x[[1]]) && CodeAnalysis::isSymbol(x[[1]][[1]], c("::", ":::"))))
    k2 = sapply(k, function(x) deparse(x[[1]]))
    w2 = gsub("^RAppian:::?", "", k2) %in% tools::undoc("RAppian", ".")$code
    unique(k2[w2])
}
