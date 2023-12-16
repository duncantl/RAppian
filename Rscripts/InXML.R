if(!exists("xml", inherits = FALSE) && !exists("xmlc", inherits = FALSE)) {
   xml = list.files(dir, pattern = "\\.xml$", recursive = TRUE, full = TRUE)
   xmlc = lapply(xml, readLines)
}


xmlRefsUUID =
    # Better name might findUUIDInXML
    #
    # This can give false positives
    # The false positives can come from the UUID appearing in commented out code
    # or in some part of the XML that doesn't actually use the reference.
    #
    # It can lead to false negatives for record types and indirect field access via relationships.
    # See GRID_TasksForLoggedInUser
    #
function(u, xml = list.files(path = path, pattern = "\\.xml$", recursive = TRUE, full = TRUE),
         xmlc = lapply(xml, readLines), path = ".")
{
    ans = sapply(xml[sapply(xmlc, function(x) any(grepl(u, x)))], getName)
    ans[ order(ans) ]
}
