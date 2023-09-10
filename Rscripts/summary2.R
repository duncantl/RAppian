dir = "."
info = mkSummary(dir)

# May want to look at the xsd files which are data types.

code2 = mkCodeInfo()

top.uuids = toplevelUUIDs()
code.uses = lapply(code2$code, function(x) uses(txt = x, toplevel = top.uuids))
nu = sapply(code.uses, length)


# The ones with no uuids sem to be
# + incomplete.
# + creating string content with ri! content
# + empty
# + using urn:appian:record-type
