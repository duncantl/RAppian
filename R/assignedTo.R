
requestTasks = 
    #
    #
    #
function(rid, db = dbDump(), current = TRUE)
{
    tasks = subset(db$TASK_LOG, REQUEST_ID == rid)
    if(current)
        tasks = subset(tasks, tasks$IS_ACTIVE & is.na(tasks$COMPLETED_BY))

    tasks
}

assignedToDB =
    #
    # Determine to whom a specific request is currently assigned
    # or the history of who dealt with that request
    #
function(rid, db = dbDump(), current = TRUE,
         tasks = requestTasks(rid, db, current))
{
    to = tasks$ASSIGNED_TO
    els = strsplit(to, ";")
    if(length(to) == 1)
        els[[1]]
    else {
        names(els) = trimws(gsub(".*\\|([^|]+)\\|.*", "\\1", tasks$TASK_NAME))
        els
    }
}

assignedTo =
    # replaced below since this needs the token
function(rid, cookie = dbCookie(inst = inst), token = dbToken(inst = inst), inst = appianInstance())    
{
    qry = sprintf("SELECT * FROM EFRM_TASK_LOG WHERE REQUEST_ID = %s;", rid)
    sql(qry, cookie, token, inst = inst)
}


assignedTo =
function(rid, cookie = dbCookie(inst = inst), token = dbToken(inst = inst), inst = appianInstance())    
{
    tbl = dbTable("EFRM_TASK_LOG", cookie)
    subset(tbl, REQUEST_ID == rid)
}


requestEmails =
    #
    # There is no TASK_LOG_ID associated with a NOTIFICATION_LOG entry
    # so can't directly connect the email to a task.
    #
function(rid, db = dbDump(), toWhom = FALSE)    
{
    ans = subset(db$NOTIFICATION_LOG, REQUEST_ID == rid)
    if(toWhom)
        structure(strsplit(ans$TO_ADDRESS, "; ?"), names = ans$SUBJECT)
    else
        ans
}
