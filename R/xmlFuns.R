library(XML)

getRuleCode = getInterfaceCode =
getDefinition =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    xpathSApply(doc, "//definition", xmlValue)
}


getConstantInfo =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    con = xmlRoot(doc)[["constant"]]
    data.frame(name = xmlValue(con[["name"]]),
               uuid = xmlValue(con[["uuid"]]),
               value = xmlValue(con[["typedValue"]][["value"]]),
               type = xmlValue(con[["typedValue"]][["type"]][["name"]]))
}


getName =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    xpathSApply(doc, "//interface/name | //rule/name | //outboundIntegration/name | /contentHaul/*[2]/name | //recordType/@name", xmlValue)
}

xmlValue.XMLAttributeValue =
function(x, ...)
      unname( x )

getDocType =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    names(xmlRoot(doc))[2]
}
