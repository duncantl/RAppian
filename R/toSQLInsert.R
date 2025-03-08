toSQLInsert =
    #
    # Purpose of this is to use rows in a data.frame
    # to create SQL to insert these rows into the specified
    # table.
    #
function(rows, table, tableDef = NULL, requestId = NA,
         timeVars = "_ON")
{
    if(nrow(rows) > 1)
        return(sapply(1:nrow(rows), \(i) toSQLInsert(rows[i,], table, tableDef, requestId, timeVars)))

    i = grep(timeVars, names(rows))
    rows[i] = replicate(length(i), Sys.time(), simplify = FALSE)
    
    w = sapply(rows, inherits, "POSIXt")
    rows[w] = sapply(rows[w], function(x) format(x, "%Y-%m-%d %H:%M:%S"))

    values = unlist(rows)
    
    w = !is.na(values) & tableDef$Extra != "auto_increment"    
    colNames = names(rows)[w]
    values = values[w]

    isString = grep("varchar|datetime", tableDef$Type[w])
    values[isString] = sprintf("'%s'", values[isString])

    i = which(colNames == "REQUEST_ID")
    if(length(i))
        values[i] = requestId

    # Leave datetime fields as character
    
    sprintf("INSERT INTO %s\n (%s) \n VALUES (%s);",
            table,
            paste(colNames, collapse = ", "),
            paste(values, collapse = ", "))
}

