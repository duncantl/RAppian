
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

assignedTo =
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


