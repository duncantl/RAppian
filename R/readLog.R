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


tomcatSummary =
function(x, fl = sapply(x, `[`, 1))
{
    rx = "^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}(,[0-9]{3})?) \\[([^]]+)\\] ([A-Z]+) (.*)"
    tmp = regmatches(fl, gregexec(rx, fl, perl = TRUE))
    w = sapply(tmp, length) > 0
    # Dropping the lines that didn't match. Most of these are ...Exception[$:.
    #
    browser()    
    tmp2 = as.data.frame(matrix(unlist(lapply(tmp[w], function(x) x[-c(1, 3), ])), , 4, byrow = TRUE))
    colnames(tmp2) = c("time", "source", "status", "message")
    tmp2
#    tmp2 = do.call(rbind, lapply(tmp, function(x) as.data.frame(t(x[-1,]))))
}
