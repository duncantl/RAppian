DBTableParams = 
c(db = "Appian", table = "D_MY_REQUEST", export_type = "table", 
export_method = "quick", temaplate_id = "", single_table = "1", 
token = "3246476f6222377b3366683a537d786d", quick_or_custom = "quick", 
what = "json", allrows = "1", aliases_new = "", output_format = "sendit", 
filename_template = "%40TABLE%40", remember_template = "on", 
charset = "utf-8", compression = "none", maxsize = "", codegen_structure_or_data = "data", 
codegen_format = "0", csv_separator = "%2C", csv_enclosed = "%22", 
csv_escaped = "%22", csv_terminated = "AUTO", csv_null = "NULL", 
csv_columns = "something", csv_structure_or_data = "data", excel_null = "NULL", 
excel_columns = "something", excel_edition = "win", excel_structure_or_data = "data", 
json_structure_or_data = "data", json_unicode = "something", 
latex_caption = "something", latex_structure_or_data = "structure_and_data", 
latex_structure_caption = "Structure+of+table+%40TABLE%40", latex_structure_continued_caption = "Structure+of+table+%40TABLE%40+%28continued%29", 
latex_structure_label = "tab%3A%40TABLE%40-structure", latex_comments = "something", 
latex_columns = "something", latex_data_caption = "Content+of+table+%40TABLE%40", 
latex_data_continued_caption = "Content+of+table+%40TABLE%40+%28continued%29", 
latex_data_label = "tab%3A%40TABLE%40-data", latex_null = "%5Ctextit%7BNULL%7D", 
mediawiki_structure_or_data = "data", mediawiki_caption = "something", 
mediawiki_headers = "something", htmlword_structure_or_data = "structure_and_data", 
htmlword_null = "NULL", ods_null = "NULL", ods_structure_or_data = "data", 
odt_structure_or_data = "structure_and_data", odt_comments = "something", 
odt_columns = "something", odt_null = "NULL", pdf_report_title = "", 
pdf_structure_or_data = "data", phparray_structure_or_data = "data", 
sql_include_comments = "something", sql_header_comment = "", 
sql_use_transaction = "something", sql_compatibility = "NONE", 
sql_structure_or_data = "structure_and_data", sql_create_table = "something", 
sql_if_not_exists = "something", sql_auto_increment = "something", 
sql_create_view = "something", sql_create_trigger = "something", 
sql_backquotes = "something", sql_type = "INSERT", sql_insert_syntax = "both", 
sql_max_query_size = "50000", sql_hex_for_binary = "something", 
sql_utc_time = "something", texytext_structure_or_data = "structure_and_data", 
texytext_null = "NULL", xml_structure_or_data = "data", xml_export_events = "something", 
xml_export_functions = "something", xml_export_procedures = "something", 
xml_export_tables = "something", xml_export_triggers = "something", 
xml_export_views = "something", xml_export_contents = "something", 
yaml_structure_or_data = "data")

dbTable =
    #
    # Not working yet.
    #
function(table, cookie = dbCookie(inst = inst), params = DBTableParams,
             url = dbURL(inst), inst = appianInstance(), ...)    
{
    params["table"] = table
    bdy = paste(names(params), params, sep = "=", collapse = "&")
    z = httpPOST(url, postfields = bdy, cookie = cookie, followlocation = TRUE, ...) # , verbose = TRUE)

    if(any(grepl("html", attr(z, "Content-Type"))))
        stop("request to database failed")

    if(grepl('class="alert alert-dange".*You have an error in your SQL syntax', z))
        stop("is ", table, " an actual table name in the database?")
    
    tableFromJSON(z)
}

tableFromJSON =
function(js)
{
    if(is.character(js))
        js = fromJSON(js)
    
    vals = js[[3]]
    RAppian:::mkDBTable(vals)
}



dbListTables =
    #
    # We do need the token for this SQL query, but not always for others.
    #
function(inst = appianInstance(), token = dbToken(inst), dbName = "Appian")
{
    # From https://stackoverflow.com/questions/8334493/get-table-names-using-select-statement-in-mysql
   sql(sprintf('SELECT table_name FROM information_schema.tables WHERE table_schema = "%s";', dbName),
        inst = inst, token = token)[,1]
}




