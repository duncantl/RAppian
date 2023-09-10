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


uses =
function(file, txt = paste(readLines(file), collapse = "\n"),
          toplevel = toplevelUUIDs())
{
    uuids = regmatches(txt, gregexpr(uuidRX3, txt))[[1]]
    if(length(toplevel))
        intersect(uuids, toplevel)
    else
        uuids
}

toplevelUUIDs =
function(dir = ".", af = list.files(dir, recursive = TRUE, pattern = "\\.xml$"))
{
    gsub("\\.xml$", "", basename(af))
}

