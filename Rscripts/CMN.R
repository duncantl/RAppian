
xml = list.files(pattern = "\\.xml$", recursive = TRUE, full = TRUE)
xmlc = lapply(xml, readLines)

i = grep("CMN", map$name)
cmn = structure(lapply(map$uuid[i], function(u) sapply(xml[sapply(xmlc,function(x) any(grepl(u, x)))], getName)), names = map$name[i])

