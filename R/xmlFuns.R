library(XML)

getRuleCode = getInterfaceCode = getCode =
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
               value = if(xmlSize(con[["typedValue"]][["value"]]) > 1)
                           paste(xmlSApply(con[["typedValue"]][["value"]], xmlValue), collapse = "; ")
                       else
                           xmlValue(con[["typedValue"]][["value"]]),
               type = xmlValue(con[["typedValue"]][["type"]][["name"]]),
               numValues = xmlSize(con[["typedValue"]][["value"]]))
}


AppianTypesNS = c(x = "http://www.appian.com/ae/types/2009")

getName =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)
    xp = switch(xmlName(r),
                "siteHaul" = "/siteHaul/site/@name",
                "processModelHaul" = "//x:process_model_port//x:meta//x:name//x:value",
                "groupHaul" = "/groupHaul/group/name",
                "groupTypeHaul" = "/groupTypeHaul/groupType/name",                
           "//interface/name | //rule/name | //outboundIntegration/name | /contentHaul/*[2]/name | //recordType/@name")

    ans = xpathSApply(doc, xp, xmlValue, namespaces = AppianTypesNS)
    if(length(ans))
        ans
    else
        NA
}


getDocType = getType =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)
    switch(xmlName(r),
           "processModelHaul" = "processModel",
           names(r)[2])
}


procModelNodes =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    getNodeSet(doc, "//x:process_model_port//x:nodes/x:node", AppianTypesNS)
}


