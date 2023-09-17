#
# For each object, find which 
#
# Should we be working from the SAIL code or from the XML
#
#

if(FALSE) {
    af = list.files(recursive = TRUE, pattern = "\\.xml$")
    top = toplevelUUIDs(af = af)
    us = lapply(af, uses, toplevel = top)
}

if(FALSE) {
    u = uses(txt = getCode(map$file[map$name == "EFRM_FORM_qeApplication"]))
    m = match(u, map$uuid )
    map[m, c("name", "type", "qname")]
    
}


uses =
    # This doesn't seem to handle #urn directly but captures
    # the UUID within the urn.
    #
    # Also, can use StoR(, TRUE) and then get the symbols from the code
    # to see what the SAIL code calls.
    # This is only focuses on the SAIL code, not the UUIDs in other parts of he
    # XML, but that includes the history, versions, permissions/roles, etc.
    #
function(file, txt = paste(readLines(file), collapse = "\n"),
         toplevel = toplevelUUIDs(),
         rx = uuidRX3)
{
    uuids = regmatches(txt, gregexpr(rx, txt))[[1]]
    if(length(toplevel))
        intersect(uuids, toplevel)
    else
        uuids
}

toplevelUUIDs =
function(dir = ".", af = xmlFiles(dir))
{
    gsub("\\.xml$", "", basename(af))
}



directUses =
    #
    # ignore constants as these are symbolic names that we want to keep for now
    #
function(w, map)
{
    i = grep(w, map$name)
    map[map$type != "constant" & map$name %in% map$uses2[[i]], ]
}


getCodeUses =
    #
    # just the sail code in an XML file, not the entire XML file.
    #
function(map, code = sapply(map$file, getCode))
{
    tmp = lapply(code, function(x) uses(txt = x, toplevel = map$uuid))
    lapply(tmp, function(x) map$name[ match(x, map$uuid) ])
}


#################

rewriteCode =
function(code, map)
{
    code = mkCode(code)
    u = ruses(code)

    vals = mapName(u, map, "name", paths = FALSE)
    w = !is.na(vals)
    if(any(w)) {
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
            out = gsub(u[i], vals[i], out)

        parse(text = out)[[1]]
    } else
        code
}

mkCode =
function(code)
{
    if(is.character(code))
        code = StoR(code, TRUE)[[1]]
   
    if(is.expression(code))
        code = code[[1]]

    code
}


ruses =
function(code)    
{
    code = mkCode(code)

    syms = unique(c(CodeAnalysis:::all_symbols(code),
                    unlist(lapply(findCallsTo(code), names))))
    grep("^(#|SYSTEM_SYSRULES_)", syms, value = TRUE)
}
