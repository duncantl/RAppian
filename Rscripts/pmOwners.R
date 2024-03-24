pms = pms(map)
ow = sapply(pms, pmOwner, map)

m = match(ow, map$uuid)
ow2 = data.frame(name = names(ow), owner = map$name[m])

byo = split(ow2$name, ow2$owner)
# m = match(names(byo), map$uuid)
#names(byo) = map$name[m]




