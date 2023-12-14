if(!exists("xml", inherits = FALSE) && !exists("xmlc", inherits = FALSE)) {
   xml = list.files(dir, pattern = "\\.xml$", recursive = TRUE, full = TRUE)
   xmlc = lapply(xml, readLines)
}


xmlRefsUUID =
function(u, xml = list.files(path = path, pattern = "\\.xml$", recursive = TRUE, full = TRUE),
         xmlc = lapply(xml, readLines), path = ".")
{
    ans = sapply(xml[sapply(xmlc, function(x) any(grepl(u, x)))], getName)
    ans[ order(ans) ]
}
