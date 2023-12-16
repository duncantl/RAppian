if(FALSE) {

    a = readLines("/tmp/db")
    p = getFormParams(a)
    pct = RCurl:::PercentCodes
    for(i in seq(along.with = pct)) {
        names(p) = gsub(pct[i], names(pct)[i], names(p))
        p = gsub(pct[i], names(pct)[i], p)        
    }
    dput(p)
}

DBParams =
    list(db = "Appian", table = "", export_type = "database", export_method = "quick", 
template_id = "", token = "6442594b6250503c40446b46547b6834", 
quick_or_custom = "quick", what = "json", structure_or_data_forced = "1", 
`table_select[]` = "CMN_APPLICATION", `table_select[]` = "CMN_LOOKUP", 
`table_select[]` = "CMN_LOOKUP_CATEGORY", `table_select[]` = "D_MY_REQUEST", 
`table_select[]` = "D_REQUEST", `table_select[]` = "EDOCS_HTTP_DEBUG", 
`table_select[]` = "EDOCS_UPLOAD_LOG", `table_select[]` = "EFRM_ADVANCEMENT_TO_CANDIDACY_DETAILS", 
`table_select[]` = "EFRM_APPROVAL_DETAILS", `table_select[]` = "EFRM_ATC_COURSEWORK_REQUIRED", 
`table_select[]` = "EFRM_COMMITTEE_MEMBERS", `table_select[]` = "EFRM_COMMITTEE_MEMBERS_BUSINESS_RULE", 
`table_select[]` = "EFRM_DEGREE_PLAN_MAP", `table_select[]` = "EFRM_DE_COMPLETION_REPORT", 
`table_select[]` = "EFRM_DOCUMENT_DETAILS", `table_select[]` = "EFRM_EFORM", 
`table_select[]` = "EFRM_EVENT_LOG", `table_select[]` = "EFRM_FILING_DETAILS", 
`table_select[]` = "EFRM_INITIATION_LOG", `table_select[]` = "EFRM_MASTERS_PLAN_II_AND_MFA_REPORT_DETAILS", 
`table_select[]` = "EFRM_NOTES", `table_select[]` = "EFRM_NOTIFICATION_LOG", 
`table_select[]` = "EFRM_PHD_EXAM_REPORT_DETAILS", `table_select[]` = "EFRM_PRM_DATA", 
`table_select[]` = "EFRM_QE_DETAILS", `table_select[]` = "EFRM_QE_REPORT", 
`table_select[]` = "EFRM_REASSIGNMENT_LOG", `table_select[]` = "EFRM_REQUEST_DETAILS", 
`table_select[]` = "EFRM_STUDENT_DETAILS", `table_select[]` = "EFRM_TASK_LOG", 
`table_select[]` = "EFRM_TASK_MASTER", `table_select[]` = "EFRM_TERM_QUARTER_DETAILS_LOOKUP", 
`table_select[]` = "EFRM_TITLE_MAP", `table_select[]` = "EFRM_WORKFLOW", 
`table_select[]` = "EXP_BOX_REPLACEMENT_ROUTING", `table_select[]` = "EXP_CHECK", 
`table_select[]` = "EXP_FORM_DESCRIPTION", `table_select[]` = "EXP_GRADUATE_DIVISION_UNITS", 
`table_select[]` = "M_MICROCREDENTIAL", `table_select[]` = "M_USER_MICRO_CREDENTIAL", 
`table_select[]` = "RWM_AA_BOT_RUNNER_LIST", `table_select[]` = "RWM_AA_STAGE_ACTIVITY_LIST", 
`table_select[]` = "RWM_AA_STAGE_AUDIT_LIST", `table_select[]` = "RWM_AA_STAGE_PROCESS_LIST", 
`table_select[]` = "RWM_AA_STAGE_QUEUE_LIST", `table_select[]` = "RWM_AA_STAGE_RESOURCE_LIST", 
`table_select[]` = "RWM_AA_STAGE_SCHEDULE_LIST", `table_select[]` = "RWM_AA_STAGE_WORK_ITEM_LIST", 
`table_select[]` = "RWM_AI_QUESTIONS", `table_select[]` = "RWM_APPLICATIONS", 
`table_select[]` = "RWM_AUDIT", `table_select[]` = "RWM_AUTOMATION", 
`table_select[]` = "RWM_AUTOMATIONS_RECORD_VIEW", `table_select[]` = "RWM_AUTOMATION_STEPS_VIEW", 
`table_select[]` = "RWM_BPM_COMPLETED_SESSIONS", `table_select[]` = "RWM_BPM_COMPLETED_SESSIONS_ARCHIVE", 
`table_select[]` = "RWM_BPM_PROCESS", `table_select[]` = "RWM_BPM_PROCESS_REPORT", 
`table_select[]` = "RWM_BP_ETL_LOG", `table_select[]` = "RWM_BP_SESSION_LOGS", 
`table_select[]` = "RWM_BP_SESSION_LOGS_EXPORT_TEMP", `table_select[]` = "RWM_BUSINESS_GROUP_ACCESS_ROLES", 
`table_select[]` = "RWM_CASE_COMMENTS", `table_select[]` = "RWM_CASE_DETAILS", 
`table_select[]` = "RWM_CASE_HISTORY", `table_select[]` = "RWM_COMPLETED_SESSIONS", 
`table_select[]` = "RWM_COMPLETED_SESSIONS_ARCHIVE", `table_select[]` = "RWM_DAYS_LOOKSUP", 
`table_select[]` = "RWM_ETL_PROCESS_LOG", `table_select[]` = "RWM_EXECUTION_STATISTICS_REPORT", 
`table_select[]` = "RWM_GET_INSTANCE_LABEL_BASEDON_PROCESS_ID", 
`table_select[]` = "RWM_IMPACT_ANALYSIS_COE_REVIEW", `table_select[]` = "RWM_INTEGRATION_LOG", 
`table_select[]` = "RWM_JD_SCHEDULER_SESSION_DETAILS", `table_select[]` = "RWM_JD_SCHEDULER_SESSION_DETAILS_ARCHIVE", 
`table_select[]` = "RWM_JD_STAGE_COMPLETED_SESSIONS", `table_select[]` = "RWM_JD_STAGE_PROCESS", 
`table_select[]` = "RWM_JD_STAGE_QUEUE_DETAILS", `table_select[]` = "RWM_JD_STAGE_QUEUE_ITEM_DETAILS", 
`table_select[]` = "RWM_JD_STAGE_RESOURCE_DETAILS", `table_select[]` = "RWM_JD_STAGE_SCHEDULER_DETAILS", 
`table_select[]` = "RWM_JD_STAGE_WORK_ITEM_DETAILS", `table_select[]` = "RWM_LOOKUP_STATUS", 
`table_select[]` = "RWM_MEMBER_ACCESSED_OBJECT_DETAILS", `table_select[]` = "RWM_MONTHLY_ASSESSMENT_DETAILS", 
`table_select[]` = "RWM_OBJECT_TYPE_DETAILS", `table_select[]` = "RWM_ONBOARDING_NEW_FLOW_DETAILS", 
`table_select[]` = "RWM_OTHER_FILES", `table_select[]` = "RWM_PREVIOUS_ONBOARDING_DETAIL", 
`table_select[]` = "RWM_PREVIOUS_SYSTEMS_VIEW", `table_select[]` = "RWM_PREVIOUS_SYSTEM_DETAILS", 
`table_select[]` = "RWM_PROCESS", `table_select[]` = "RWM_PROCESS_APPLICATIONS", 
`table_select[]` = "RWM_PROCESS_DETAILS_VIEW", `table_select[]` = "RWM_PROCESS_GRID_VW", 
`table_select[]` = "RWM_PROCESS_HISTORY", `table_select[]` = "RWM_PROCESS_INFO_IN_RESOURCE_VW", 
`table_select[]` = "RWM_PROCESS_ONBOARDING", `table_select[]` = "RWM_PROCESS_ONBOARDING_HISTORY", 
`table_select[]` = "RWM_PROCESS_ONBOARDING_QUESTIONS", `table_select[]` = "RWM_PROCESS_ONBOARDING_VIEW", 
`table_select[]` = "RWM_PROCESS_SESSION_DETAILS", `table_select[]` = "RWM_QUEUEITEMS_STATISTICS_REPORT_VIEW", 
`table_select[]` = "RWM_QUEUE_DETAILS", `table_select[]` = "RWM_QUEUE_ITEMS_EXPORT_TEMP", 
`table_select[]` = "RWM_QUEUE_ITEM_DETAILS", `table_select[]` = "RWM_QUEUE_ITEM_DETAILS_ARCHIVE", 
`table_select[]` = "RWM_QUEUE_ITEM_DETAILS_SUMMARY_VIEW", `table_select[]` = "RWM_QUEUE_RECORDS", 
`table_select[]` = "RWM_RESOURCES_SESSION_DETAILS", `table_select[]` = "RWM_RESOURCE_ALERTS", 
`table_select[]` = "RWM_RESOURCE_DETAILS_VIEW", `table_select[]` = "RWM_RESOURCE_PROCESS_DETAILS_VIEW", 
`table_select[]` = "RWM_RESOURCE_STATISTICS_DETAILS_VIEW", `table_select[]` = "RWM_RESOURCE_STATUS_DETAILS", 
`table_select[]` = "RWM_RPA_ENVIRONMENT_DETAILS", `table_select[]` = "RWM_RPA_SCHEDULES_DETAILS", 
`table_select[]` = "RWM_SAVINGS_TYPES", `table_select[]` = "RWM_SCHEDULER_DETAILS", 
`table_select[]` = "RWM_SCHEDULER_DETAILS_AA", `table_select[]` = "RWM_SCHEDULER_DETAILS_VIEW", 
`table_select[]` = "RWM_SCHEDULE_ALERTS", `table_select[]` = "RWM_SCHEDULING_DAYS", 
`table_select[]` = "RWM_SCORE_ASSESSMENT", `table_select[]` = "RWM_SESSION_STATISTICS_VIEW", 
`table_select[]` = "RWM_UI_HBT_LAST_UPDATED_STATUS", `table_select[]` = "RWM_UI_PROCESS_QUEUE_VIEW", 
`table_select[]` = "RWM_UI_SP_AUDIT_VIEW", `table_select[]` = "RWM_UI_SP_PROCESS_DETAILS_VIEW", 
`table_select[]` = "RWM_UI_SP_RESOURCE_DETAILS_VIEW", `table_select[]` = "RWM_UI_STAGE_AUDIT", 
`table_select[]` = "RWM_UI_STAGE_JOBS", `table_select[]` = "RWM_UI_STAGE_PROCESS", 
`table_select[]` = "RWM_UI_STAGE_QUEUEDEFINITIONS", `table_select[]` = "RWM_UI_STAGE_QUEUEITEMS", 
`table_select[]` = "RWM_UI_STAGE_RELEASE", `table_select[]` = "RWM_UI_STAGE_ROBOT", 
`table_select[]` = "RWM_UI_STAGE_SCHEDULER", `table_select[]` = "RWM_UI_STAGE_SESSION", 
`table_select[]` = "RWM_UI_STAGE_VERSIONS", `table_select[]` = "RWM_UI_STAGE_WORKITEMEVENTS", 
`table_select[]` = "RWM_UI_TENANT_DETAILS", `table_select[]` = "RWM_VALUE_ASSESSMENT", 
`table_select[]` = "RWM_WORK_ITEM_DETAILS", `table_select[]` = "RWM_WORK_ITEM_DETAILS_ARCHIVE", 
`table_select[]` = "RWM_WORK_ITEM_STATISTICS_VIEW", `table_select[]` = "UCD_MOCK_ACTION_HISTORY", 
`table_select[]` = "VS_TESTING", `table_select[]` = "WAT_LEGACY_HANDLER", 
`table_select[]` = "WAT_SIMPLE_ELIGIBILITY_DETAILS", aliases_new = "", 
output_format = "sendit", filename_template = "@DATABASE@", remember_template = "on", 
charset = "utf-8", compression = "none", maxsize = "", codegen_structure_or_data = "data", 
codegen_format = "0", csv_separator = ",", csv_enclosed = "\"", 
csv_escaped = "\"", csv_terminated = "AUTO", csv_null = "NULL", 
csv_columns = "something", csv_structure_or_data = "data", excel_null = "NULL", 
excel_columns = "something", excel_edition = "win", excel_structure_or_data = "data", 
json_structure_or_data = "data", json_unicode = "something", 
latex_caption = "something", latex_structure_or_data = "structure_and_data", 
latex_structure_caption = "Structure+of+table+@TABLE@", latex_structure_continued_caption = "Structure+of+table+@TABLE@+(continued)", 
latex_structure_label = "tab:@TABLE@-structure", latex_comments = "something", 
latex_columns = "something", latex_data_caption = "Content+of+table+@TABLE@", 
latex_data_continued_caption = "Content+of+table+@TABLE@+(continued)", 
latex_data_label = "tab:@TABLE@-data", latex_null = "%5Ctextit{NULL}", 
mediawiki_structure_or_data = "structure_and_data", mediawiki_caption = "something", 
mediawiki_headers = "something", htmlword_structure_or_data = "structure_and_data", 
htmlword_null = "NULL", ods_null = "NULL", ods_structure_or_data = "data", 
odt_structure_or_data = "structure_and_data", odt_comments = "something", 
odt_columns = "something", odt_null = "NULL", pdf_report_title = "", 
pdf_structure_or_data = "structure_and_data", phparray_structure_or_data = "data", 
sql_include_comments = "something", sql_header_comment = "", 
sql_use_transaction = "something", sql_compatibility = "NONE", 
sql_structure_or_data = "structure_and_data", sql_create_table = "something", 
sql_auto_increment = "something", sql_create_view = "something", 
sql_procedure_function = "something", sql_create_trigger = "something", 
sql_backquotes = "something", sql_type = "INSERT", sql_insert_syntax = "both", 
sql_max_query_size = "50000", sql_hex_for_binary = "something", 
sql_utc_time = "something", texytext_structure_or_data = "structure_and_data", 
texytext_null = "NULL", xml_structure_or_data = "data", xml_export_events = "something", 
xml_export_functions = "something", xml_export_procedures = "something", 
xml_export_tables = "something", xml_export_triggers = "something", 
xml_export_views = "something", xml_export_contents = "something", 
yaml_structure_or_data = "data")


dbDump =
    #
    #  Can we renew the token by visiting
    #    https://ucdavisdev.appiancloud.com/database/index.php
    #  with the previous token?
    #
    #
function(con = mkDBCon(...), params = DBParams,
         url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/export",
         read = TRUE, ...)
{
    json = postForm(url, .params = params, curl = con, style = "post")

    # Check we got a valid result and if not, raise an error now rather
    # than when parsing the result as JSON when it is not.
    a = attributes(json)
    if( ! ("Content-Type" %in% names(a)) ||
        a$"Content-Type"[1] != "text/plain")
        stop("Didn't get the database content - probably an expired cookie")
    
    if(read)
        readDBDump(json)
    else
        json
}

mkDBCon =
function(cookie = getDBCookie(), ...)
{
    getCurlHandle(cookie = cookie, followlocation = TRUE, cookiejar = "")
}

getDBCookie =
    #
    # The cookie is sufficiently short that it can be readily pasted into
    # the R session and it is sufficiently short-lived that it doesn't
    # necessarily warrant saving to a file for reuse in a different R session.
    #
function()
{
    ff = c("~/appiandev.cookie", "~/appian.cookie", "appian.cookie")
    w = file.exists(ff)
    if(!any(w))
        stop("cannot find Gradhub cookie")

    if(sum(w) == 1)
        ff = ff[w]
    else {
        info = file.info(ff[w])
        ff = ff[w][which.max(info$mtime)]
    }
    
    readLines(ff, warn = FALSE)[1]
}
