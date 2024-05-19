library(XML)

getRuleCode = getInterfaceCode = getCode =
getDefinition =
# Get the SAIL code from an Appian object        
function(doc, map = NULL, noCode = NA)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

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
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

    con = xmlRoot(doc)[["constant"]]
    data.frame(name = xmlValue(con[["name"]]),
               uuid = xmlValue(con[["uuid"]]),
               value = if(xmlSize(con[["typedValue"]][["value"]]) > 1)
                           paste(xmlSApply(con[["typedValue"]][["value"]], xmlValue), collapse = "; ")
                       else
                           xmlValue(con[["typedValue"]][["value"]]),
               type = xmlValue(con[["typedValue"]][["type"]][["name"]]),
               numValues = xmlSize(con[["typedValue"]][["value"]]),
               file = docName(doc))
}


AppianTypesNS = c(x = "http://www.appian.com/ae/types/2009")

getName =
    #
    # get name of an Appian object
    #
function(doc)
{
    if((is.logical(doc) || is.character(doc)) && is.na(doc))
        return(NA)
    
    if(is.name(doc))
        return(gsub("^[^!]*!", "", as.character(doc)))
    
    if(is.character(doc))
        doc = xmlParse(doc)

    r = xmlRoot(doc)

    if(xmlName(r) == "applicationPatches")
        return("AppPatches")
    
    xp = switch(xmlName(r),
                "siteHaul" = "/siteHaul/site/@name",
                "processModelHaul" = "//x:process_model_port//x:meta//x:name//x:value",
                "groupHaul" = "/groupHaul/group/name",
                "groupTypeHaul" = "/groupTypeHaul/groupType/name",
                tempoReportHaul = "/tempoReportHaul/tempoReport/@name",
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
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

    r = xmlRoot(doc)
    switch(xmlName(r),
           #XXX extend to cover more cases.
           "processModelHaul" = "processModel",
           "applicationPatches" = xmlName(r),
           names(r)[2])
}



getFolder =
    # look for the parentUuid element of the XML as the folder.
function(doc, map = NULL)
{
    if(is.character(doc)) 
        doc = xmlParse(mapFile(doc, map))

    ans = xpathSApply(doc, "//parentUuid", xmlValue)
    if(length(ans) == 0) {
        ans = switch(xmlName(xmlRoot(doc)),
                     "processModelHaul" = xpathSApply(doc, "//folderUuid", xmlValue),
                     NA)
    }
    
    ans
}


getFolders =
function(dir = ".", files = xmlFiles(dir))
{
    fld = sapply(files, getFolder)
    names(fld) = files

    # map the unique folder UUIDs to a name
    u = unique(fld)
    names(u) = u

    w = !is.na(u) & isUUID(u)
    u[w] = sapply( u[w], function(x) getName(uuid2File(x, dir = dir, missing = NA)))

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
        doc = xmlParse(mapFile(doc, map))

    ans = do.call(rbind, xpathApply(doc, "//x:interface//x:namedTypedValue | //contentHaul//namedTypedValue", mkRIDesc, namespaces = AppianTypesNS))
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
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(mapFile(doc, map))

    type = getType(doc)
    xp = switch(type,
                site = "/siteHaul/site/description",
                interface = "/contentHaul/interface/description",
                recordType = "/recordTypeHaul/recordType/x:description",
                processModel = "//x:process_model_port/x:pm/x:meta/x:desc//x:value",
                "//description")
           

    ans = xpathSApply(doc, xp, xmlValue, namespaces = AppianTypesNS)
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
