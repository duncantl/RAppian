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
    v = getConstantInfo(map$file[ match(tmp, map$name) ])$value
    strsplit(v, "; ")[[1]][i]
}

