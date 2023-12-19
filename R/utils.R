uuid2File =
    # How related to mapFile() in summarizeFlow.R
function(x, dir = ".", missing = TRUE)
{
    if(file.exists(x))
        return(x)

 if(FALSE) {
    ff = file.path(dir, "content", paste0(x, ".xml"))
    if(file.exists(ff))
        return(ff)

    ff = file.path(dir, "recordType", paste0(x, ".xml"))
    if(file.exists(ff))
        return(ff)
 }
    
    ffs = list.files(dir, pattern = "\\.xml$", full.names = TRUE, recursive = TRUE)
    i = grep(paste0("^", x), basename(ffs))
#    i = pmatch(x, basename(ffs))
    if(length(i) == 0) {
        if(isTRUE(missing))
            stop("couldn't match ", x, " to a file")
        else
            return(missing)
    }
    

    ffs[i]
}
