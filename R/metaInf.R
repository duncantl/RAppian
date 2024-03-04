readExportLog =
function(file = file.path(metaInfDir(dir), "export.log"), ll = readLines(file), dir = ".")
{
    w = grepl(":$", ll)
    g = split(ll, cumsum(w))
    
    ids = sapply(g, `[`, 1)
    g = lapply(g, function(x) x[-1])
    names(g) = trimws(gsub("\\([0-9,]+\\)$", "", gsub(":$", "", ids)))
    g
}

guidance =
function(map = mkSummary(), file = file.path(metaInfDir(dir), "design-guidance.json"), dir = ".")
{
    dg = fromJSON(file)
    df = do.call(rbind, lapply(dg, as.data.frame))

    m = match(df$objectUuid, map$uuid)
    df$name = map$name[m]

    df$objectTypeName = gsub("^\\{http://www.appian.com/ae/types/2009\\}", "", df$objectTypeName)

    df$key = gsub(".*\\.", "", df$designGuidanceKey)
    vars = c("name", "key", "dismissed", "instanceCount",
             "objectTypeName", "designGuidanceKey", "objectUuid")
    df[, vars]
}

metaInfDir =
function(dir = ".")
{
    file.path(path.expand(dir), "META-INF")
}
