# Also, see callGraph.R developed without thinking of this code!
#
# For each object, find which ....?????
#
# Should we be working from the SAIL code or from the XML
#
#

if(FALSE) {
    af = xmlFiles(dir) # list.files(recursive = TRUE, pattern = "\\.xml$")
    top = toplevelUUIDs(af = af)
    us = lapply(af, RAppian:::uses0, toplevel = top)
}

if(FALSE) {
    u = uses(txt = getCode(map$file[map$name == "EFRM_FORM_qeApplication"]))
    m = match(u, map$uuid )
    map[m, c("name", "type", "qname")]
    
}


uses = ruses =
    #
    # Different from uses0() below, this function gets argument names which are important
    # since in SAIL we have  #urn... : value and we map this to `#urn..` =
    # so we need the argument names.
    #
function(code, uuids = FALSE)    
{
    code = mkCode(code)

    syms = setdiff(unique(c(all_symbols(code),
                            unlist(lapply(findCallsTo(code), names)))), "")
    if(uuids)
        grep("^(#|SYSTEM_SYSRULES_)", syms, value = TRUE)
    else
        syms
}


if(FALSE) {
tmp = '#"urn:appian:[^:]+:v1:([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/?)+"'
#tmp = '#"urn:appian:[^:]+:v1:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})*)"'

RX2 = sprintf('(#"%s)"|(%s)', uuidRX3, tmp)
#              '((_a-)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(_[0-9]+)?)|(#"urn:appian:[^:]+:v1:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})*)"'
}


#uses =
uses0 =
    # This doesn't seem to handle #urn directly but captures
    # the UUID within the urn.
    #
    # Also, can use StoR(, TRUE) and then get the symbols from the code
    # to see what the SAIL code calls.
    # This only focuses on the SAIL code, not the UUIDs in other parts of the
    # XML, which includes the history, versions, permissions/roles, etc.
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
    #
    # Get the UUIDs of the top-level objects across all objects
    # in the Appian application.
    #
function(dir = ".", xf = xmlFiles(dir), simple = TRUE)
{
    if(simple)
        gsub("\\.xml$", "", basename(xf))
    else
        sapply(xf, getUUID)
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


if(FALSE) {
getCodeUses =
    #
    # See ruses() instead.
    # just the sail code in an XML file, not the entire XML file.
    #
function(map, code = sapply(map$file, getCode))
{
    tmp = lapply(code, function(x) uses(txt = x, toplevel = map$uuid))
    lapply(tmp, function(x) map$name[ match(x, map$uuid) ])
}
}


# Local call graph
lgraph =
    #
    # lgraph("EFRM_getNextAssigneeByProgramCodeAndRoleCodes", rcode2)
    # 
function(id, rcode)    
{
    localFuns = function(x) {
        funs = getGlobals(x)$functions
        funs = gsub(".*!", "", funs)
        funs[ funs %in% names(rcode)]
    }

    todo = id
    ans = list()
    while(length(todo)) {
        # cat("length(todo)", length(todo), "\n")
        id = todo[1]
        ans[[id]] = localFuns(rcode[[id]])
        todo = todo[-1]
        todo = setdiff(c(todo, ans[[id]]), names(ans))
    }

    structure(ans, class = "CallInfo")
}

toGraph =
    #  g = toGraph(lgraph("EFRM_getNextAssigneeByProgramCodeAndRoleCodes", rcode2))
    #  plot(g)
    #
    #
    # g = toGraph(lgraph("EFRM_getCurrentAndNextTaskLogForQeAppAdvisorCoordinator", rcode2), function(x) gsub("^EFRM_", "", x))
function(x, filter = NULL)
{
    if(is.function(filter)) {
        names(x) = filter(names(x))
        x = lapply(x, filter)
    }
        
   igraph::graph_from_edgelist(cbind(rep(names(x), sapply(x, length)), unlist(x)))
}




