pms = pms(map)
#ow = sapply(pms, mapFile, map)
ow = sapply(pms, RAppian:::pmOwner, map)
byo = split(names(ow), ow)

m = match(names(byo), map$uuid)
names(byo) = map$name[m]

#w = map$type == "processModel"
#ow = sapply(map$file[w], RAppian:::pmOwner)
#names(ow) = map$name[w]



