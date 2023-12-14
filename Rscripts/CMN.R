source("InXML.R")

i = grep("CMN", map$name)
cmn = structure(lapply(map$uuid[i], xmlRefsUUID, xmlc = xmlc), names = map$name[i])

