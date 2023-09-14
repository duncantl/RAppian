uuid2File =
function(x, dir = ".")
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
    
    ffs = list.files(dir, pattern = "\\.xml$", full = TRUE, recursive = TRUE)
    i = grep(paste0("^", x), basename(ffs))
#    i = pmatch(x, basename(ffs))
    if(length(i) == 0)
        stop("couldn't match ", x, " to a file")

    ffs[i]
}
