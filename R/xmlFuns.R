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

    r = xmlRoot(doc)
    xp = switch(xmlName(r),
           "processModelHaul" = "//x:process_model_port//x:meta//x:name//x:value",
           "//interface/name | //rule/name | //outboundIntegration/name | /contentHaul/*[2]/name | //recordType/@name")

    xpathSApply(doc, xp, xmlValue, namespaces = c(x = "http://www.appian.com/ae/types/2009"))
}

xmlValue.XMLAttributeValue =
function(x, ...)
      unname( x )

getDocType =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)
    switch(xmlName(r),
           "processModelHaul" = "processModel",
           names()[2])
}
