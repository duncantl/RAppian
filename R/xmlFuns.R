library(XML)

getRuleCode = getInterfaceCode = getCode =
getDefinition =
# Get the SAIL code from an Appian object        
function(doc, noCode = NA)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = xpathSApply(doc, "//definition", xmlValue)
    if(length(ans) == 0)
        noCode
    else
        ans
}


getConstantInfo =
    #
    # get a data.frame providing details of a constant object.
    #
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
    #
    # get name of an Appian object
    #
function(doc)
{
    if(is.na(doc))
        return(NA)
    
    if(is.name(doc))
        return(gsub("^[^!]*!", "", as.character(doc)))
    
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)
    xp = switch(xmlName(r),
                "siteHaul" = "/siteHaul/site/@name",
                "processModelHaul" = "//x:process_model_port//x:meta//x:name//x:value",
                "groupHaul" = "/groupHaul/group/name",
                "groupTypeHaul" = "/groupTypeHaul/groupType/name",                
           "//interface/name | //rule/name | //outboundIntegration/name | /contentHaul/*[2]/name | //recordType/@name | /*/*/name")

    ans = xpathSApply(doc, xp, xmlValue, namespaces = AppianTypesNS)
    if(length(ans))
        ans
    else
        NA
}


getDocType = getType =
    #
    # get type of an Appian object
    #
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)
    switch(xmlName(r),
           "processModelHaul" = "processModel",
           names(r)[2])
}


if(FALSE) {
procModelNodes =
    #
    # get the nodes of an Appian process model
    #
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    getNodeSet(doc, "//x:process_model_port//x:nodes/x:node", AppianTypesNS)
}
}



getFolder =
    # look for the parentUuid element of the XML as the folder.
function(doc)
{
    if(is.character(doc)) 
        doc = xmlParse(doc)

    ans = xpathSApply(doc, "//parentUuid", xmlValue)
    if(length(ans) == 0) {
        ans = switch(xmlName(xmlRoot(doc)),
                     "processModelHaul" = xpathSApply(doc, "//folderUuid", xmlValue),
                     NA)
    }
    
    ans
}


getFolders =
function(files = xmlFiles())
{
    fld = sapply(files, getFolder)
    names(fld) = files

    # map the unique folder UUIDs to a name
    u = unique(fld)
    names(u) = u

    w = !is.na(u) & isUUID(u)
    u[w] = sapply( u[w], function(x) getName(uuid2File(x, missing = NA)))

    # Now use these names as the values for fld, keeping the original xml file name
    # as the names of the vector.
    ans = fld
    ans[!is.na(fld)] = u[ fld[!is.na(fld) ] ]
    ans
}


orNA =
function(x, val = NA)
{
    if(length(x) == 0)
        val
    else
        x
}



ruleInputs =
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = do.call(rbind, xpathApply(doc, "//interface//namedTypedValue", mkRIDesc))
    if(!is.null(map)) {
        w = isUUID(ans$type)
        ans$type[w] = mapUUID(ans$type[w], map, "name")
    }
    

    ans
}

mkRIDesc =
function(x)
{
    data.frame(name = xmlValue(x[["name"]]),
               type = xmlValue(x[["type"]][["name"]]))
}

                


getDescription =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = xpathSApply(doc, "//description", xmlValue)
    if(length(ans) == 0)
        NA
    else
        ans
}






mkDoc =
function(doc)    
{
    if(is.character(doc))
        doc = xmlParse(doc)

    doc
}
