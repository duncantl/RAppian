# Examine the process models and find all the subprocesses used within these
#

pm = map$file[map$type == "processModel"]
pm.docs = lapply(pm, function(x) xmlParse(x))
names(pm.docs) = sapply(pm.docs, getName)

subs = lapply(pm.docs, getSubProcessUUIDs)
subs = subs[sapply(subs, length) > 0]

tt = table(unlist(subs))
m = match(names(tt), map$uuid)

z = data.frame(parent = rep(names(subs), sapply(subs, length)),
               subproc = unlist(subs))

m = match(z$subproc, map$uuid)
z$subprocName = map$name[m]
