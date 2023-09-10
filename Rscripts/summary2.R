xf = list.files(recursive = TRUE, full = TRUE, pattern = "\\.xml$")
af = list.files(recursive = TRUE, full = TRUE)

# Extensions of the non .xml files
dsort(table(tools::file_ext(setdiff(af, xf))))


info = data.frame(name = sapply(xf, getName),
                  type = sapply(xf, getDocType),
                  file = xf)


# May want to look at the xsd files which are data types.

code = lapply(xf, getCode)
names(code) = xf
code = code[sapply(code, length) > 0]

code2 = data.frame(name = sapply(names(code), getName),
                   type = sapply(names(code), getDocType),
                   file = names(code),
                   code = code)

top.uuids = toplevelUUIDs()
code.uses = lapply(code, function(x) uses(txt = x, toplevel = top.uuids))
nu = sapply(code.uses, length)


# The ones with no uuids sem to be
# + incomplete.
# + creating string content with ri! content
# + empty
# + using urn:appian:record-type
