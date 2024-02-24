sql =
    #
    # Need the token (?)
    # Don't need to escape the query.
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355", k)
    # For now, can only get maximum of 25 records.
    # Have the code somewhere to set this via the an HTTP request.
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY = 'sbdriver'") 
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY IN ('sbdriver', 'sligday')", k)
    #  
    #
function(query, cookie, token = NA, url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/import", ...)
{
    bdy = mkPOSTBody(query, token)
    z = httpPOST(url, postfields = bdy, cookie = cookie, followlocation = TRUE, ...) # , verbose = TRUE)

    ct = attr(z, "Content-Type")
    if(ct[1] == "text/html")
        stop("query returned HTML. Probably stale cookie and/or token")
    
    readDBResults(z)
}

mkPOSTBody =
    #
    # Create the body of the POST request by merging the parameters into a name=value&name=value...
    #
function(query, token = NA, table = NA, params = RAppian:::DefaultParams)    
{
    if(!is.na(token)) 
        params[names(params) == "token"] = token

    if(!is.na(table)) 
        params[names(params) == "table"] = table


    if("_nocache" %in% names(params))
        params["_nocache"] = as.character( as.numeric(Sys.time()) * 1e9)
    
    params["sql_query"] = query

    paste(names(params), params, sep = "=", collapse = "&")
}


readDBResults =
function(x, results = fromJSON(x))
{
    if(!results$success) {
        # Get the message from text. Not useful. We didn't lint.
        stop("SQL query wasn't succesful")
    }
    
    readDBResultsFromHTML(htmlParse(results$message))
}

readDBResultsFromHTML =
function(doc)
{
    if(is.character(doc))
        doc = htmlParse(doc)

    tbls = getNodeSet(doc, "//table")
    if(length(tbls) == 0) {
        warning("no results table")
        return(NULL)
    }
    

    tbl = tbls[[ if(length(tbls) > 1L) 2L else 1L]]
    #    browser()
    # The query SHOW TABLES returns a table with 2 columns but the second is empty except
    # in the header row. And the td for the second column in the header row
    # has @class=d-print-none 
    colNames = xpathSApply(tbl, ".//thead//th[@data-column]/@data-column")
    d = readHTMLTable(tbl)
    if(is.null(d))
        return(NULL)
    
    # When should we be removing these? It is for the edit, delete, copy.
    #
    if(nrow(d) > 0 && ncol(d) > 3 && all(d[1, 1:3, drop = TRUE] == c("", " Edit", " Copy")))
        d = d[, -(1:4)]
    
    names(d) = colNames
    
    d
}
