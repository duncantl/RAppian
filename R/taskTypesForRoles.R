mkTaskRoleUnitMap =
function(x, map)
{
    tmp = as.list(x$taskMasterIds)[-1]
    taskIds = sapply(tmp, mapConsValue, map)
    role = mapConsValue(x$roleCode, map)

    data.frame(unit = rep(x$programUnit, length(taskIds)),
               role = rep(role, length(taskIds)),
               taskIds = taskIds)
}

mapConsValue =
function(x, map)
{
    if(is.call(x)) {
        i = x[[3]]
        con = x[[2]]
    } else {
        con = x
        i = 1
    }
    
    tmp = gsub("constant!", "", as.character(con))
    info = getConstantInfo(map$file[ match(tmp, map$name) ])
    val = strsplit(info$value, "; ")[[1]][i]

    cvtConstantValue(val, info)
    
#    val
}

cvtConstantValue =
function(val, info)
{
    ty = gsub("\\?list", "", info$type)
    switch(ty,
           text = ,
           string = val,
           Integer = ,
           int = as.integer(val),
           boolean = as.logical(val),
           val
           )
}
