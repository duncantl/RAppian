if(FALSE) {
    k = lapply(rcode2[!err], findCallsTo)
    k2 = sapply(k, function(x) sapply(x, function(x) deparse(x[[1]])))
    wr = sapply(k2, function(x) grep("write", x, value = TRUE, ignore.case = TRUE))

    wr = wr[sapply(wr, length) > 0]
    names(wr)


    pms = lapply(map$file[map$type == "processModel"], function(x) try(summarizeProcModel(x, map)))
    err.pm = sapply(pms, inherits, 'try-error')
#    pms[!err.pm]
    z = lapply(pms[!err.pm], pmWriteRecords, map)
}


pmWriteRecords =
function(pm, map)
{
    isWrite = !is.na(pm$nodes$icon) & pm$nodes$icon == "Write Record"
    if(any(isWrite)) {
        acps = pm$nodes[isWrite, "ACPs"]
        ty = sapply(acps, function(y) {
                             w = y$name == "RecordType"
                              y$code[w]
        })
        resolveURN(fixURN(ty), map)
        
    } else
       character()
}


