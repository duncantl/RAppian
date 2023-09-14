if(FALSE) {
   counts = do.call(rbind, lapply(rf, function(x) {
        tt = table(xpathSApply(xmlParse(x), "//field | //x:recordRelationshipCfg | //x:fieldCfg", xmlName, namespaces = AppianTypesNS))
        id = c("field", "fieldCfg", "recordRelationshipCfg")
        tt[ id [ !( id %in% names(tt) ) ] ] = 0L
        tt[id]
        }))
   cbind(unname(sapply(rf, getName)), as.data.frame(counts))
}


recordType =
    # Use recordTypeInfo()
    #
    #
    # Started and realized was duplicating recordTypeInfo
    # But what is the difference between <a:fieldCfg> and <field> in the XML?
    # It appears every record type XML file has <field> elements, but 
    # some also have 
    #
    # recordType
    #   fieldCfg fieldCfg fieldCfg
    #   recordRelationshipCfg recordRelationshipCfg
    #   sourceConfiguration
    #       field field field
    #
    # field is in sourceConfiguration
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = xpathApply(doc, "//x:fieldCfg", mkFieldCfg, namespaces = AppianTypesNS)

    if(length(ans) == 0) {
        #        //field | //x:recordRelationshipCfg
        ans = recordTypeInfo(doc)
        cfg = getNodeSet(doc, "//x:recordRelationshipCfg", AppianTypesNS)
        return(ans)
    }
    
    ans = do.call(rbind, ans)
    w = grep("^is", names(ans))
    ans[w] = lapply(ans[w], function(x) x == "true")

    r = xmlRoot(doc)
    rt = r[["recordType"]]
    ans$record.uuid = xmlGetAttr( rt, "uuid")
    ans$record.name = xmlGetAttr( rt, "name")
    ans$record.description = xmlValue(rt[["description"]])
    
    ans
}

mkFieldCfg =
function(x)
{
    ans = data.frame(Name = xmlGetAttr(x, "name"),
                     uuid = xmlGetAttr(x, "uuid"))    
    v = c("description", "sourceRef", "isFacet", "facetType", "isExclusiveFacet", "facetLabelExpr")
    ans[v] = lapply(x[v], xmlValue)
 
    w = names(x) == "relatedRecordFieldUuid"
    ans$relatedRecordFieldUuid = paste(sapply(x[w], xmlValue), collapse = ";")
   
    ans
}

recordTypeRelationships =
    #
    # Gets the recordRelationshipCfg from an XML file describing a Record Type
    #
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = do.call(rbind, xpathApply(doc, "//x:recordRelationshipCfg", mkRecordRelationshipCfg, namespaces = AppianTypesNS))
    rownames(ans) = NULL
    ans
}

mkRecordRelationshipCfg =
function(x)    
{
    rel = RJSONIO::fromJSON(xmlValue(x[["relationshipData"]]))
    target = xmlValue(x[["targetRecordTypeUuid"]])
    type = xmlValue(x[["relationshipType"]])
    data.frame(sourceField = rel["sourceRecordTypeFieldUuid"],
               targetField = rel["targetRecordTypeFieldUuid"],
               targetRecordType = target,
               type = type,
               uuid = xmlValue(x[["uuid"]])
               )
    
}

getUUID =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

#    ty = xmlName(xmlRoot(doc))
#    xp = switch(ty,
#                "applicationHaul" = "/*/recordType/@x:uuid",
#                "applicationHaul" = "/*/recordType/@x:uuid",                

# unname(getNodeSet(doc, "/*/recordType/@x:uuid", AppianTypesNS))
    
    xp = "/*/*[2]/uuid | /*/*[2]/@x:uuid | /processModelHaul/x:process_model_port/x:pm/x:meta/x:uuid"
    unname(xpathSApply(doc, xp, xmlValue, namespaces = AppianTypesNS))
}


recordTypeInfo =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    tmp = do.call(rbind, xpathApply(doc, "//field", mkFieldInfo))
    logicalVars = c("isRecordId", "isCustomField")
    tmp[ logicalVars] = lapply(tmp[logicalVars], function(x) x == "true")
    
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
    vars = c("fieldName", "sourceFieldType", "isRecordId", "isCustomField", "uuid")

    # [Fixed] Bug in XML package  [.XMLNode
    tmp = structure(lapply(x[vars], xmlValue), names = vars)
    # Changes the order of the results in x[vars] and
    # so setting the names puts the fieldName on sourceFieldType and vice verse
    #

    as.data.frame(tmp)
}

showRecordType = recordType2Markdown =
function(doc, info = recordTypeInfo(doc), name = getName(doc))
{
    c(paste0("+ ", name),
      sprintf("   +  %s (%s) ", info$fieldName, info$sourceFieldType))
}


recordTypeList =
    #
    # Get a list of the record types for this application
    # Each element is a data.frame with the fieldName, type, isRecordID, isCustomField, UUID
    #
    # This is hopefully enugh to resolve #urn:appian:record-field and #urn:appian:record-type
    # references.
    #
    # Not enough for #urn:appian:record-relationship. For that, we'll need to
    # use other functions above.
    #
function(dir = ".", files = list.files(dir, full.names = TRUE, pattern = "\\.xml"))
{
  structure( lapply(files, recordType), names = sapply(files, getName))
}
