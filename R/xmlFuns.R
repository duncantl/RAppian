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


getDocType =
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


recordTypeInfo =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    tmp = do.call(rbind, xpathApply(doc, "//field", mkFieldInfo))
    tmp$isRecordId = (tmp$isRecordId == "true")
    
    tmp
}

mkFieldInfo =
    #
    # For recordTypeInfo
    # return a 1-row data.frame describing the field
    #
    # Todo
    # + add relationsthip(s) to other tables.
    #
function(x)
{
    vars = c("fieldName", "sourceFieldType", "isRecordId")

    # XX Bug in XML package  [.XMLNode
    tmp = structure(lapply(x[vars, all = TRUE], xmlValue), names = vars)
    # Changes the order of the results in x[vars] or x[vars, all = TRUE] and
    # so setting the names puts the fieldName on sourceFieldType and vice verse
    #

#    tmp = lapply(x[vars, all = TRUE], xmlValue)
#    tmp = tmp[vars]
    
    as.data.frame(tmp)
}

showRecordType =
function(doc, info = recordTypeInfo(doc), name = getName(doc))
{
    c(paste0("+ ", name),
      sprintf("   +  %s (%s) ", info$fieldName, info$sourceFieldType))
}
