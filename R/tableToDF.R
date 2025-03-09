table2df =
function(x, map = NULL)
{
    if(length(x) == 1)
        ans = data.frame(name = names(x), count = as.integer(x))
    else        
        ans = data.frame(name = rownames(x), count = as.integer(x))

    if(!is.null(map)) {
        tmp = gsub(".*!", "",  ans$name)
        m = match(tmp, map$name, 0)
        ans$description = ""
        if(any(m != 0)) 
            ans$description[m != 0] = map$description[m]
    }

    ans
}

mkCountDfs =
function(map, syms)
{
    tmp2 = list("Overall Type Count" =  table2df(dsort(table(map$type))))
    
    tt = dsort(table(unlist(syms)))
    w = grepl("^SYSTEM_SYSRULES_", names(tt))
    names(tt)[w] = gsub("^SYSTEM_SYSRULES_", "a!", names(tt)[w])
    
    category = c(rule = "rule!", constant = "constant!",
                 interface = "interface!",
                 integration = "outboundIntegration!",
                 processModel = "pm!",             
                 recordType = "recordType!",
                 system = "a!", fn = "fn!", fv = "fv!")
    tmp2[names(category)] = lapply(paste0("^", category), function(rx) table2df( tt[ grep(rx, names(tt) )], map))

    tmp2
}


       
