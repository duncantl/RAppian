getCustomizationConstants =
function(file, txt = readLines(file))
{
    i = grep("^## Constant: ", txt)
    gsub("^## Constant: ", "", txt[i])
}


isEnvSpecific =
function(doc)
{
    doc = mkDoc(doc)
    getType(doc) == "constant" && xpathSApply(doc, "//isEnvironmentSpecific", xmlValue) == "true"
}
