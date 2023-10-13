getCustomizationConstants =
function(file, txt = readLines(files))
{
    i = grep("^## Constant: ", txt)
    gsub("^## Constant: ", "", txt[i])
}
