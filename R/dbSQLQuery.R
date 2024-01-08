
sql =
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355", k)
    # For now, can only get maximum of 25 records
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY = 'sbdriver'") 
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY IN ('sbdriver', 'sligday')", k)
    #  
    #
function(query, cookie, token = NA, url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/import", ...)
{
    bdy = mkPOSTBody(query, token)
    z = httpPOST(url, postfields = bdy, cookie = k, followlocation = TRUE, ...) # , verbose = TRUE)
    a = readDBResults(z)
}

mkPOSTBody =
    #
    # Create the body of the POST request by merging the parameters into a name=value&name=value...
    #
function(query, token = NA, params = DefaultParams)    
{
    if(!is.na(token)) 
        params[names(params) == "token"] = token

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

    tbl = getNodeSet(doc, "//table")[[2]]
#    browser()    
    colNames = xpathSApply(tbl, ".//thead//th[@data-column]/@data-column")
    d = readHTMLTable(tbl)
    d = d[, -(1:4)]
    names(d) = colNames
    
    d
}
