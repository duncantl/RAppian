# See summarizeFlow.R


procModelPos =
    #
    # Doesn't show the connections yet.
    #
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    vars = c(x = "x", y = "y", label = "fname//x:value")
    tmp = lapply(paste0("//x:nodes//x:", vars),
                 function(q) xpathSApply(doc, q, xmlValue, trim = TRUE, namespaces = AppianTypesNS))

    ans = structure(as.data.frame(tmp), names = names(vars))
    ans[c("x", "y")] =    lapply(ans[c("x", "y")] , as.integer)
    structure(ans, class = c("ProcessModelPositions", class(ans)))
}

plot.ProcessModelPositions =
function(x, y, ...)    
    plotProcModel(x, ...)

plotProcModel =
function(doc, pm = procModelPos(doc), cex = .6, ...)
{
    plot(1, xlim = c(0, max(pm$x)), ylim = c(0, max(pm$y)), type = "n", axes = FALSE, xlab = "", ylab = "")
    box()
    text(pm$x, max(pm$y) - pm$y, pm$label, cex = cex)
}


iconType =c("Write Record" = "155",
            "Interface" = "21",
            "End Node" = "50",
            "End Event" = "51",
            "AND" = "52",
            "XOR" = "58",
            "OR" = "56",             
            "Script Task" = "68",
            "Subprocess" = "60", #XX reconcile these two
            "Subprocess" = "998", #XXX
            "Send E-Mail" = "84",
            "Generate Word Document" = "152",
            "Delete Word Document" = "763"
           )


if(FALSE)  {
procModelNodes0 =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    # ¿Why doing this variable by variable and not node by node?
    vars = c(x = "x", y = "y", label = "fname//x:value", lane = "lane")
    tmp = lapply(paste0("//x:nodes/x:node/x:", vars),
                 function(q) xpathSApply(doc, q, xmlValue, trim = TRUE, namespaces = AppianTypesNS))

    ans = structure(as.data.frame(tmp), names = names(vars))
    ans[c("x", "y")] = lapply(ans[c("x", "y")] , as.integer)
    ans$uuid = xpathSApply(doc, "//x:nodes/x:node", xmlGetAttr, "uuid", namespaces = AppianTypesNS)
    
    icon = xpathSApply(doc, "//x:nodes/x:node/x:icon", xmlGetAttr, "id", namespaces = AppianTypesNS)
    ans$icon = names(iconType)[ match(icon, iconType) ]
    names(ans)[names(ans) == "icon"] = "nodeType"

    ans
}
}

procModelNodes = procNodes =
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    nodes = getNodeSet(doc, "//x:nodes/x:node", namespaces = AppianTypesNS)
    
    ans = do.call(rbind, lapply(nodes, mkProcModelNode)) 
    ans[c("x", "y")] = lapply(ans[c("x", "y")] , as.integer)
    ans$icon = names(iconType)[ match(ans$icon, iconType) ]

    ln = lanes(doc)
    ans$lane = factor( names(ln)[ as.integer(ans$lane) + 1L ], names(ln))

    # Activity class parameters for each node.
    ans$ACPs = lapply(nodes, function(node) doACPs(getNodeSet(node, ".//x:ac/x:acps/x:acp", namespaces = AppianTypesNS), map))
    ans$numACPs = sapply(ans$ACPs, NROW) 

    # connections to other nodes
    cons = lapply(nodes, function(x) getNodeSet(x, ".//x:connections/x:connection", AppianTypesNS))
    ans$connections = lapply(cons, function(x)
                                       do.call(rbind, lapply(x, mkConnectionDF)))
    ans$numConnections = sapply(ans$connections, NROW)
    
    ans
}

mkConnectionDF =
function(x)
{
    tmp = x[["chained"]]
    chained = if(is.null(tmp))
                  FALSE
              else
                  as.logical(toupper(xmlValue(tmp)))
    
    data.frame(to = xmlValue(x[["to"]]),
               label = xmlValue(x[["flowLabel"]]),
               chained = chained
              )    
}


doACPs =
    #
    # process a collection of acp nodes.
    # Have other code that does this call this function.
    #
function(acps, map)    
{
    if(length(acps) == 0)
#       return(structure(list(),
#                        names = c("label", "guiId", "icon", "uuid", "lane",
#                                  "x", "y", "hasCustomOutputs", "hasInterface", "numCustomOutputs"),
#                        class = "data.frame"))
        return(NULL)

    tmp = lapply(acps, mkAcp, map)
    ans = as.data.frame(do.call(rbind, tmp))
    
    if(length(map)) 
        ans$type = fixType(ans$type, map)

    ans
}


mkProcModelNode =
function(x)
{
    # Add the ACPs for each node in procNodes() to simplify
    # dealing with a list in the larger data.frame.
    
    data.frame(label = getPMNodeName(x[["fname"]]),
               guiId = xmlValue(x[["guiId"]]),               
               icon = xmlGetAttr(x[["icon"]], "id"),               
               uuid = xmlGetAttr(x, "uuid"),
               lane = xmlValue(x[["lane"]]),
               x = xmlValue(x[["x"]]),
               y = xmlValue(x[["y"]]),
               hasCustomOutputs = length(getNodeSet(x, ".//x:ac/x:output-exprs/x:el", AppianTypesNS)) > 0,
               hasInterface = length(getNodeSet(x, ".//x:interfaceInformation", AppianTypesNS)) > 0,
               numCustomOutputs = length(getNodeSet(x, ".//x:output-exprs/x:el", AppianTypesNS))
               #               userInteraction = xmlValue()
              )
}

getPMNodeName =
    # Can also use for "desc"
function(x, el = character()) # "fname")
{
    if(length(el))
        x = x[[el]]
    
    xmlValue(x[["string-map"]][["pair"]][["value"]])
}


procVars = procModelVars =
   #  "processModel/0002ea7f-5596-8000-fc23-7f0000014e7a.xml"
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = do.call(rbind, xpathApply(doc, "//x:pvs/x:pv", mkProcessVar, namespaces = AppianTypesNS))

    v = c("required", "hidden", "parameter")
    ans[v] = lapply(ans[v], function(x) x == "true")
    ans$type = gsub("^n1:", "", ans$type)
    if(!is.null(map)) {
        w = isUUID(ans$type)
        ans$type[w] = mapUUID(ans$type[w], map, "name")
    }
    
    ans
}

mkProcessVar =
function(x)
{
    data.frame(name = xmlGetAttr(x, "name"),
               type = xmlGetAttr(x[["value"]], "type"),               
               required = xmlValue(x[["required"]]),
               hidden = xmlValue(x[["hidden"]]),
               parameter = xmlValue(x[["parameter"]]))
}


lanes =
function(doc, map = NULL)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = getNodeSet(doc, "//x:lanes/x:lane", AppianTypesNS)
    names(ans) = sapply(ans, function(x) xmlValue(x[["laneLabel"]]))
    ans
}

customParams =
    # customParams("processModel/0002eab7-e965-8000-03e1-7f0000014e7a.xml")
function(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
{
    doc = mkDoc(doc)

    # consolidate with doACPs
    acps = getNodeSet(doc, "//x:node//x:custom-params//x:acp", AppianTypesNS)
    if(length(acps) == 0)
        return(NULL)

    ans = doACPs(acps, map)

    lvars = c("required", "editable", "inputToActivityClass", "hiddenFromDesigner", "generated")
    ans[lvars] = lapply(ans[lvars], toLogical)
    
    if(toR) {
        ans$code = lapply(ans$code, StoR, TRUE) # function(x) StoR(x, TRUE)[[1]])

        if(rewrite)
            ans$code = lapply(ans$code, rewriteCode, map)
    }

    ans
}

toLogical =
function(x)    
{
    if(all(x %in% c("0", "1")))
        x == 1
    else if(all(x %in% c("true", "false")))
        x == "true"
        
}

mkCustomParam = mkAcp =
function(x, map = NULL)    
{
   tmp = data.frame(name = xmlGetAttr(x, "name"),
                    type = xmlGetAttr(x[["value"]], "type"),
                    code = xmlValue(x[["expr"]]),
                    required = xmlValue(x[["required"]]),
                    editable = xmlValue(x[["editable"]]),
                    assignToPV = xmlValue(x[["assign-to-pv"]]),
                    inputToActivityClass = xmlValue(x[["input-to-activity-class"]]),               
                    hiddenFromDesigner = xmlValue(x[["hidden-from-designer"]]),               
                    generated = xmlValue(x[["generated"]]),
                    enumeration = xmlValue(x[["enumeration"]]),               
                    customDisplayReference = xmlValue(x[["customDisplayReference"]])
                    )

   tmp$value = list(getAppValue(x[["value"]], map))
   tmp
}


customInputs =
    # customInputs("processModel/0002ea7f-5596-8000-fc23-7f0000014e7a.xml", map)
function(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
{
    doc = mkDoc(doc)
    
    acps = getNodeSet(doc, "//x:node//x:acp[./x:input-to-activity-class = 'true']", AppianTypesNS)
    if(length(acps) == 0)
        return(NULL)

    # doACPs returns a data.frame
    ans = doACPs(acps, map)

    if(toR) {
        ans$code = lapply(ans$code, StoR, parse = TRUE)
        if(rewrite)
            ans$code = lapply(ans$code, rewriteCode, map, parse = FALSE)
    }
    
    ans
}

customOutputs =
function(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    nn = getNodeSet(doc, "//x:node[.//x:output-exprs/x:el]", AppianTypesNS)
    ans = lapply(nn, getNodeCustomOutputs, map = map)

    ids = sapply(nn, getPMNodeName, "fname")

    if(asDF) {
        if(length(ans) == 0)
            return(NULL)
        
        tmp = ans
        ans = as.data.frame(do.call(rbind, unlist(ans, recursive = FALSE)))
        ans[1:2] = lapply(ans[1:2], unlist)
        ans$type = as.integer(ans$type)
        # node name
        ans$nodeName = rep(ids, sapply(tmp, length))
        ans$uuid = rep(sapply(nn, xmlGetAttr, "uuid"), sapply(tmp, length))
        
        if(toR) {
            ans$code = lapply(ans$code, function(x)
                                           tryCatch(StoR(x, TRUE, procModel = TRUE),
                                                    error = function(e) {
                                                        warning("failed to convert SAIL code to R: ", e)
                                                        NA
                                                    })) # function(x) StoR(x, TRUE)[[1]])
            
            ans$target = sapply(ans$code, function(x) if(length(x) > 1 && is.name(x[[2]])) as.character(x[[2]]) else NA)
        }
        
        if(rewrite && !is.null(map))
            ans$code = lapply(ans$code, rewriteCode, map)

    } else
        names(ans) = ids
    
    ans
}

getNodeCustomOutputs =
function(x, map = NULL)    
{
    xpathApply(x, ".//x:output-exprs/x:el", mkCustomOutputEl, namespaces = AppianTypesNS, map = map)
}

mkCustomOutputEl =
function(x, map = NULL)
{
    code = xmlValue(x)

#    code = StoR(xmlValue(x), TRUE)
#    if(!is.null(map))
#        code = rewriteCode(code, map)
    
    list(code = code, type = xmlGetAttr(x, "typeFlag"))
}


procName = processName =
    #
    # This is the dynamic process name, not the name of the of the process model given by the author for the Appian object.
    #
function(doc)
{
    doc = mkDoc(doc)

    x = getNodeSet(doc, "//x:meta//x:process-name", AppianTypesNS)
    getPMNodeName(x[[1]]) # , "process-name")
}


fixType =
function(x, map)    
{
    w = grepl("^n1:", x)
    x[w] = mapUUID(gsub("^n1:", "", x[w]), map, "name")
    x
}


getAppValue =
    #
    # If type == "a:Bean?list", then this is a a list of acp objects
    #
function(x, map = NULL, type = xmlGetAttr(x, "type"))
{
    hasContent = xmlSize(x)
    switch(type,
           "a:Processodel" = xmlGetAttr(x, "id", NA),
           "xsd:string" = xmlValue(x),
           "xsd:int" = as.integer(xmlValue(x)),
           "xsd:boolean" = xmlValue(x) == "true",
           "a:Bean?list" = if(xmlSize(x[["acps"]]) > 0)
                               doACPs(xmlChildren(x[["acps"]]), map)
                           else
                               NA,
           NA
           )
}



interfaceInfo =
function(doc, map = NULL, dir = Rlibstree::getCommonPrefix(map$file))
{
    doc = mkDoc(doc)
    ans = xpathApply(doc, "//x:interfaceInformation",
                     mkInterfaceInfo, map = map, dir = dir,
                     namespaces = AppianTypesNS)
    names(ans) = sapply(ans, `[[`, "name")
    ans
}

mkInterfaceInfo =
function(x, map = NULL, code = TRUE, dir = Rlibstree::getCommonPrefix(map$file))    
{
    if(xmlSize(x[["ruleInputs"]]) > 0)
        ri = do.call(rbind, xmlApply(x[["ruleInputs"]], mkInterfaceInfoRI))
    else
        ri = data.frame()

    ans = list(name = xmlValue(x[["name"]]),
               uuid = xmlValue(x[["uuid"]]),
               ruleInputs = ri)
    if(code)  {
        # can also get it by mapping the uuid to a uuid2File()
        # and

        m = match(ans$uuid, map$uuid)
        if(!is.na(m)) {
            tmp = if("code" %in% names(map))
                      map$code [[ m ]]
                  else
                      rewriteCode(StoR(getCode(uuid2File(ans$uuid, dir, map = map)), TRUE), map)
            
            ans$code = tmp
        } else
            warning("couldn't find the UUID ", ans$uuid, " in the map")
    }
    
    ans
}

mkInterfaceInfoRI =
    # RI - rule input
function(x)    
{
    data.frame(name = xmlValue(x[["name"]]),
               type = xmlValue(x[["typeQName"]]),
               value = xmlValue(x[["value"]]))
}


getSubProcessUUIDs =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    xpathSApply(doc, "//x:node[./x:icon/@id = '60']//x:ac//x:acp[@name = 'pmUUID']/x:value",
                xmlValue, namespaces = AppianTypesNS)    
}
