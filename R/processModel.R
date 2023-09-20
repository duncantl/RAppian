procModelPos =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    vars = c(x = "x", y = "y", label = "fname//x:value")
    tmp = lapply(paste0("//x:nodes//x:", vars),
                 function(q) xpathSApply(doc, q, xmlValue, trim = TRUE, namespaces = AppianTypesNS))

    ans = structure(as.data.frame(tmp), names = names(vars))
    ans[c("x", "y")] =    lapply(ans[c("x", "y")] , as.integer)
    ans
}

plotProcModel =
function(doc, pm = procModelPos(doc), cex = .6)
{
    plot(1, xlim = c(0, max(pm$x)), ylim = c(0, max(pm$y)), type = "n", axes = FALSE, xlab = "", ylab = "")
    box()
    text(pm$x, max(pm$y) - pm$y, pm$label, cex = cex)
}

iconType =c("Write Record" = "155", "Interface" = "21",
            "End Node" = "50", "End Event" = "51",
            "AND" = "52",
            "XOR" = "58", 
            "Script Task" = "68",
            "Subprocess" = "60", #XX reconcile these two
            "Subprocess" = "998", #XXX
            "Send E-Mail" = "84",
            "Generate Word Document" = "152",
            "Delete Word Document" = "763")


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

procModelNodes =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    ans = do.call(rbind, xpathApply(doc, "//x:nodes/x:node", mkProcModelNode, namespaces = AppianTypesNS))
    ans[c("x", "y")] = lapply(ans[c("x", "y")] , as.integer)
    ans$icon = names(iconType)[ match(ans$icon, iconType) ]

    ln = lanes(doc)
    ans$lane = factor( names(ln)[ as.integer(ans$lane) + 1L ], names(ln))
    
    ans
}


mkProcModelNode =
function(x)
{
    data.frame(label = getPMNodeName(x[[1]][["fname"]]),
               guiId = xmlValue(x[["guiId"]]),               
               icon = xmlGetAttr(x[["icon"]], "id"),               
               lane = xmlValue(x[["lane"]]),
               uuid = xmlGetAttr(x, "uuid"),
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


procVars = processVars =
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
               required = xmlValue(x[["required"]]),
               hidden = xmlValue(x[["hidden"]]),
               type = xmlGetAttr(x[["value"]], "type"),
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


customOutputs =
function(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    nn = getNodeSet(doc, "//x:node[.//x:output-exprs/x:el]", AppianTypesNS)
    ans = lapply(nn, getNodeCustomOutputs, map = map)

    ids = sapply(nn, getPMNodeName, "fname")
    if(asDF) {
        tmp = ans
        ans = as.data.frame(do.call(rbind, unlist(ans, recursive = FALSE)))
        ans[1:2] = lapply(ans[1:2], unlist)
        ans$type = as.integer(ans$type)
        ans$elName = rep(ids, sapply(tmp, length))

        if(toR) {
            ans$code = lapply(ans$code, function(x) StoR(x, TRUE)[[1]])
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
