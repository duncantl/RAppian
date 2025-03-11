toSQLInsert =
    #
    # Purpose of this is to use rows in a data.frame
    # to create SQL to insert these rows into the specified
    # table.
    #
function(rows, table, tableDef = NULL, requestId = NA,
         timeVars = "_ON$")
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

    # should process other characters such as ;
    values[isString] = sapply(values[isString], sqlQuote) # sqlAposQuote

    i = which(colNames == "REQUEST_ID")
    if(length(i))
        values[i] = requestId

    
    # Leave datetime fields as character
    sprintf("INSERT INTO %s\n (%s) \n VALUES (%s);",
            table,
            paste(colNames, collapse = ", "),
            paste(values, collapse = ", "))
}

if(FALSE) {
    tst = c("'abc'xyz", "Ellen Hartigan-O'Connor", "abc'")
    sapply(tst, sqlAposQuote)

    tst2 = c("'abc'xyz", "Ellen Hartigan-O'Connor", "abc'", "Science & Technology")
    sapply(tst, sqlQuote)    
}

sqlQuote =
function(x)    
{
    m = c("'" = 39, "&" = 38)
    for(i in names(m))
        x = RAppian:::sqlAposQuote(x, sprintf("CHAR(%d)", m[i]), i)

    gsub("'+$", "'", gsub("^'+", "'", x))
    
#    x
}

sqlAposQuote =
    # This is for creating a literal string or a call to CONCAT()
    # so the result can be used in a SQL query.
    #
    # Turns a string into either
    #   single-quoted, e.g., 'xyz'
    #   call to CONCAT(), replacing ' with CHAR(39)
    #
    # Takes a single string for now.
function(x, value = "CHAR(39)", char = "'")
{
    if(!grepl(char, x))
        return(sprintf("'%s'", x))

    # Now deal with a ' in the string and create
    #  CONCAT( part1, CHAR(39), part2, CHAR(39), ...)
    # But have to deal with ' at the start or the end.
    
    els = strsplit(x, char)[[1]]
    atStart = grepl(paste0("^", char), x)
    if(atStart)
        els = els[-1]

    els = sprintf("'%s'", els)    

    tmp = paste(els, collapse = paste0(", ", value, ", "))

    
    if(grepl(paste0(char, "$"), x))
        tmp = paste0(tmp, ", ", value)
    if(atStart) 
        tmp = paste0(value, ", ", tmp)
    
    sprintf("CONCAT(%s)", tmp)
}

        
