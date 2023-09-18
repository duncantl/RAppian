#
# Take a SAIL code string and change the UUIDs/urns/SYSTEM_RULES etc. to human readable names.
#
# Different approaches
# + use StoR() and find the symbols and the subset we want to transform and then
#   + regular expressions to transform
#      + the SAIL code
#      + the deparsed R code
#   + the R language objects
#      + via a recursive function or
#      + walkCode() from
#      + rstatic
#
#


rewriteCode =
function(code, map, warn = FALSE)
{
    code = mkCode(code)

    if(length(code) == 0)
        return(code)
    
    u = ruses(code)
    # Should this focus only on items starting with #
    # Currently can return : [ studentDetails pv!requestDetails
    u = u[grep("^#", u)]
    
    vals = mapName(u, map, "name", paths = FALSE)
    
    w = !is.na(vals)

    if(any(!w)) {
        if(warn)
            warning("couldn't map ", paste(unique(u[!w]), collapse = ", "))
        u = u[w]
        vals = vals[w]
    }
    
    
    if(length(u)) {
        out = deparse(code, backtick = TRUE, nlines = -1L) # , collapse = "\n")
        # deparse() decides to remove the `` around SYSTEM_SYSRULES that we had put there in StoR().
        # So we have to put them back as we will change that to a!funcName and need to put that in ` `.
        out = gsub("(SYSTEM_SYSRULES_[^(]+)\\(", "`\\1`(", out)
        
        for(i in seq(along.with = u)) 
            out = gsub(u[i], vals[i], out, fixed = TRUE)

        parse(text = out)[[1]]
    } else
        code
}



if(FALSE) {
    #  map$code[map$name == "EFRM_constructApplicationDocument"]
    
x = "#\"urn:appian:record-type:v1:3126e56d-456d-4b76-a46b-3d610e957723\"(\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/6713e51c-f2d4-43e3-9765-9f1472433fa8\": ri!requestId,\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/3ef24b9b-583b-4a1f-8f88-1227450ad7df\": tointeger(ri!document),\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f\": #\"_a-0000ea6a-ed23-8000-9bab-011c48011c48_106166\",\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/48164125-aa38-4693-b985-6513aeaf1a6a\": tostring(ri!initiator),\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/e55761fd-d58b-4375-869c-15b902265a2a\": now(),\n  #\"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/9b15b538-1e35-4463-8843-0e859cf6c3eb\": true\n)"

    # uses() doesn't currently handle full urn's  or multipart UUIDs so misses many of the entries in x.
    # Can make uses() recognize these, but for now, look at the R code.
    
    r = StoR(x, TRUE)
    # all_symbols also doesn't get the record-field, etc. It is not getting the argument names.
    # But the following does.
    u =  grep("^#", unique(c(CodeAnalysis:::all_symbols(r), unlist(lapply(findCallsTo(r[[1]]), names)))), value = TRUE)

    

# cutting from Appian Designer gives.    
"
'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details'(
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{6713e51c-f2d4-43e3-9765-9f1472433fa8}requestId': ri!requestId,
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{3ef24b9b-583b-4a1f-8f88-1227450ad7df}appianDocId': tointeger(ri!document),
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{1fbdec7e-9bcb-4589-a387-6addfd158e8f}docTypeId': cons!EFRM_DOC_TYPE_APPLICATION_DOCUMENT,
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{48164125-aa38-4693-b985-6513aeaf1a6a}addedBy': tostring(ri!initiator),
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{e55761fd-d58b-4375-869c-15b902265a2a}addedOn': now(),
  'recordType!{3126e56d-456d-4b76-a46b-3d610e957723}EFRM Document Details.fields.{9b15b538-1e35-4463-8843-0e859cf6c3eb}isActive': true
)"
}
