sql =
    #
    # Don't always need the token.
    # Don't need to escape the query.
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355", k)
    #
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY = 'sbdriver'") 
    # z = sql("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355 AND ACCEPTED_BY IN ('sbdriver', 'sligday')", k)
    #  
    #
    # "https://gradspheredev.ucdavis.edu/database/index.php?route=/import"
    #
    # √ Need to get next pages of results.
    #
    # Now gets the cookie and token by reading db<instance>.cookie and .token
    #
    #  o = sql("SELECT * FROM EFRM_DEGREE_PLAN_MAP",  maxRecords = 100)
    #
function(query, cookie = dbCookie(), token = dbToken(),
         url = gsub("/export$", "/import", dbURL(inst)), inst = appianInstance(), maxRecords = Inf,
         verbose = FALSE,
         con = getCurlHandle(..., cookie = cookie),
         ...)
{
    ans = sqlGetNextPage(query, cookie, token, pos = 0L, url = url, con = con, ...)

    nr = attr(ans, "totalRecords")

    if(length(nr) && !is.na(nr)) {
        if(verbose)
            message(nr, " total records ", ceiling(nr/25), " requests")
        while(nrow(ans) < nr && nrow(ans) < maxRecords) {
            if(verbose)
                message("next page ", nrow(ans))
            tmp = sqlGetNextPage(query, cookie, token, pos = nrow(ans) - 1L, url = url, con = con)
            ans = rbind(ans, tmp)
        }
    }

    ans[] = lapply(ans, cvtDBColumn)
    ans
}

sqlGetNextPage =
function(query, cookie, token, pos = 25L, url, con = getCurlHandle(..., cookie = cookie), ...)
{
    bdy = mkPOSTBody(query, token, pos = pos)
    z = httpPOST(url, postfields = bdy, cookie = cookie, followlocation = TRUE, ..., curl = con) # , verbose = TRUE)

    ct = attr(z, "Content-Type")
    if(ct[1] == "text/html")
        stop("query returned HTML. Probably stale cookie and/or token")

    ans = readDBResults(z)    
}


mkPOSTBody =
    #
    # Create the body of the POST request by merging the parameters into a name=value&name=value...
    #
function(query, token = NA, table = NA, params = RAppian:::DefaultParams, pos = 0L)    
{
    if(!is.na(token)) 
        params[names(params) == "token"] = token

    if(!is.na(table)) 
        params[names(params) == "table"] = table


    if("_nocache" %in% names(params))
        params["_nocache"] = as.character( as.numeric(Sys.time()) * 1e9)
    
    params["sql_query"] = query
    params["pos"] = pos

    paste(names(params), params, sep = "=", collapse = "&")
}


readDBResults =
function(x, results = fromJSON(x))
{
    if(!results$success) {
        # Get the message from text. Not useful. We didn't lint.
        #
        doc = htmlParse(results$error)
        err = getNodeSet(doc, "//code[starts-with(., '#')]")
        stop("SQL query wasn't succesful: ", xmlValue(err[[1]]))
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

    attr(d, "totalRecords") = numRecordsTotal(doc)
    
    d
}

numRecordsTotal =
    function(doc)
{
    node = getNodeSet(doc, "//div[@class='alert alert-success']//text()[ contains(., 'total, Query took')]")

    if(length(node) == 0)
        return(NA)

    as.integer(gsub(".*\\(([0-9]+) total, Query took.*", "\\1", xmlValue(node[[1]])))
}
