#  'recordType!{f46db558-8af9-47a4-88a7-c759a0b3445f}EFRM Task Log.fields.{0b021633-2d37-4759-a376-bbd613501104}taskMasterId',

# For Request Details.requestId
# a!defaultValue(
#    value: ri!requestId,
#    default: ri!requestDetails['recordType!{5ad7f584-ce54-41f6-a287-5fcf34d87702}EFRM Request Details.fields.{b3b96eb8-996b-44bb-b614-34e3dc4badf7}requestId']
#  ),

genRecordTypeCode = 
function(name = "EFRM Task Log", map,
         rhs = mkDefaultValue)
{
    file = map$file[map$name == name]
    doc = RAppian:::mkDoc(file)
    uuid = getUUID(file)
    rt = recordTypeInfo(file)

    flds = mkRecordTypeFieldAccessors(uuid, name, rt)

    if(tis.function(rhs)) {
        rhs(flds, rt, uuid, name)
    } else
        flds
}

mkRecordTypeFieldAccessors =
function(uuid, name, rt)
{
    sprintf("'recordType!{%s}%s.fields.{%s}%s'",
            uuid,
            name,
            rt$uuid,
            rt$fieldName)    
}

mkDefaultValue =
function(flds, rt, uuid, name)
{
    indent = sapply(nchar(rt$fieldName) + nchar(name) + nchar("a!defaultValue") + 1,
                    function(n) paste(rep(" ", n), collapse = ""))
   sprintf("%s: %s, ",
           flds, sprintf("a!defaultValue(value: ri!%s,\n%sdefault: ri!orig[%s])",
                         rt$fieldName,
                         indent,
                         flds))
}
