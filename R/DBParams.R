DefaultParams =
    list(db = "Appian",
         table = "EFRM_EFORM",
         token = NA,
         is_js_confirmed = "0",
         pos = "0",
         goto = "index.php%3Froute%3D%2Ftable%2Fsql", 
         message_to_show = "Your+SQL+query+has+been+executed+successfully.", 
         prev_sql_query = "SELECT+COUNT(*)+FROM+%60EFRM_EFORM%60+WHERE+1", 
         sql_query = "SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = 355", 
         sql_delimiter = "%3B",
         fk_checks = "0",
         fk_checks = "1",
         SQL = "Go", 
         ajax_request = "true",
         ajax_page_request = "true",
         `_nocache` = "1704674033662935885",
#                      170467720075
# as.numeric(Sys.time())*100
         token = NA
         )

SetNRowsParams =
    # specific to a table.
c(ajax_request = "true",
  ajax_page_request = "true",
  db = "Appian", 
  table = "EFRM_APPROVAL_DETAILS",
  server = "1",
  sql_query = "SELECT+*+FROM+%60EFRM_APPROVAL_DETAILS%60+WHERE+1%3B", 
  is_browse_distinct = "",
  goto = "index.php%3Froute%3D%2Ftable%2Fstructure", 
  pos = "0",
  unlim_num_rows = "179",
  token = NA, 
  session_max_rows = "500",
  `_nocache` = "1704727334182728755", 
  token = NA
 )

getDefaultDBParams =
function(token = getOption("AppianDBToken", stop("No Appian DB token")),
         params = DefaultParams)    
{
    params[names(params) == "token"] =  token
    params
}


if(FALSE) {
    url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/import"
    cmd = mkPOSTBody(NA, params = SetNRowsParams, token = token, table = "EFRM_TASK_LOG")
    z = httpPOST(url, postfields = cmd, cookie = k)
}

