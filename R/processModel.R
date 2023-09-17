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
function(doc, pm = procModelPos(doc))
{
    plot(1, xlim = c(0, max(pm$x)), ylim = c(0, max(pm$y)), type = "n")
    text(pm$x, max(pm$y) - pm$y, pm$label, cex = .6)
}

procModelNodes =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    vars = c(x = "x", y = "y", label = "fname//x:value", lane = "lane")
    tmp = lapply(paste0("//x:nodes/x:node/x:", vars),
                 function(q) xpathSApply(doc, q, xmlValue, trim = TRUE, namespaces = AppianTypesNS))

    ans = structure(as.data.frame(tmp), names = names(vars))
    ans[c("x", "y")] =    lapply(ans[c("x", "y")] , as.integer)
    ans$uuid = xpathSApply(doc, "//x:nodes/x:node", xmlGetAttr, "uuid", namespaces = AppianTypesNS)
    ans
}


processVars =
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
