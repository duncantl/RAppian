library(RAppian)
# dir = "."
info = mkSummary(dir)

# May want to look at the xsd files which are data types.

code2 = mkCodeInfo(dir)

top.uuids = toplevelUUIDs(dir)
code.uses = lapply(code2$code, function(x) RAppian:::uses0(txt = x, toplevel = top.uuids))  # was uses but should be uses0
nu = sapply(code.uses, length)
table(nu)


# The ones with no uuids sem to be
# + incomplete.
# + creating string content with ri! content
# + empty
# + using urn:appian:record-type
