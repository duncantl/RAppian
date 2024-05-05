fun = mkUsesFun2(names(rcode2))
ty = (map$type == "processModel")
tmp = lapply(map$file[ty], function(file) try(names(procModelUses(file, map, fun))))
names(tmp) = map$name[ty]
err2 = sapply(tmp, inherits, 'try-error')
g2 = data.frame(calls = rep(map$name[ty][!err2], sapply(tmp[!err2], length)), called = unlist(tmp[!err2]))
       

