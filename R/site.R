siteInfo =
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

    do.call(rbind, xpathApply(doc, "//page", mkSitePage))
}

mkSitePage =
function(x)
{
    data.frame(name = xmlValue(x[["staticName"]]),
               uuid = xmlGetAttr(x[["uiObject"]], "uuid"),
               description = xmlValue(x[["description"]]),
               visibility = xmlValue(x[["visibilityExpr"]])
               )
}
