readTomcatLog =
function(x)    
{
    if(is.raw(x))
        x = strsplit(rawToChar(x), "\\n")[[1]]
    else if(length(x) == 1 && file.exists(x))
        x = readLines(x)
    else if(length(x) == 1)
        x = strsplit(x, "\\n")[[1]]

    w = grepl("^[^[:space:]]", x)
    g = split(x, cumsum(w))
    
}
