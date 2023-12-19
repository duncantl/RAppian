# Choose better names now that this is in a package and not
# just for use in my own session.
# These were written as discardable one-off helper functions
# for TaskTrack.md in PhaseI. They could be useful for other
# case studies and the names could be better and the design too

changed = diff =
    # Which tables are different in the two database snapshots
function(new, prev, op = identical)
    names(new)[sapply(names(new), function(v) isFALSE(op(new[[v]], prev[[v]])))]

showDiffs =
    # for each table that is different in the two databases
    # show the differences, subsetting to the REQUEST_ID == id
    # for each table in both the new and previous.
function(new, prev, id = 94)
{
    # call changed above.
    w = !sapply(names(new), function(v) identical(new[[v]], prev[[v]]))
    invisible(lapply(names(new)[w],
                     function(v)
                         showDiffDF( new , prev, v, id)))
}

showDiffDF =
    # Get the table in each database (new and prev) with the name table
    # and subset each where the REQUEST_ID equals id.
    # The show whether what has changed
    #   1) new rows
    #   2) changes to existing rows
    #   3) both 1) and 2)
function(new, prev, table, id = 94)
{
    cat("##", table, "\n\n")
    a = subsetTables(new, prev, table, id)
    new2 = a$new2
    prev2 = a$prev2
    
    if(nrow(new2) != nrow(prev2)) {
        idx = seq_len(min(nrow(new2), nrow(prev2)))
        if(length(idx) > 0 && !isTRUE( a <- all.equal(new2[idx,], prev2[idx,]))) {
            cat("**** Changes in existing rows and new rows for", table, "\n\n")
            print(changedRecords(new2, prev2))
        }
        
        print(list(new = new2, old = prev2))
    } else {
        print(all.equal(new2, prev2))
    }
}

subsetTables =
function(new, prev, table, id)    
{
    list(new2 = subset(new[[table]], REQUEST_ID == id),
         prev2 = subset(prev[[table]], REQUEST_ID == id))
}

cmp =
    # Check whether the subset of rows for the two tables
    # in the databases are the same
    # cmp(d1, d0, "TASK_LOG")
function(new, prev, table, id = 94)    
{
    new2 = subset(new[[table]], REQUEST_ID == id)
    prev2 = subset(prev[[table]], REQUEST_ID == id)
    all.equal(new2, prev2)
}

stack =
    # Get table from each database snapshot
    # and subset the based on REQUEST_ID == id
    # Then return the new and the old/previous tables
    # so we can compare row by row.
    #
    #  This doesn't actually stack except in the sense it
    #  the result prints the new on top of the previous
    #  subset.
    #
    #   stack(d1, d0, "TASK_LOG")
    #
    #   do.call(rbind, stack(d1, d0, "TASK_LOG"))
    #   tmp = do.call(rbind, stack(d1, d0, "TASK_LOG"))
    #   split(tmp, tmp[,1])
    #
function(new, prev, table, id = 94)    
{
    new2 = subset(new[[table]], REQUEST_ID == id)
    prev2 = subset(prev[[table]], REQUEST_ID == id)
    list(new = new2, old = prev2)
}


changedRecords =
    #
    # already subsetted
    #
function(new2, prev2)
{
    if(nrow(prev2) == 0)
        return(list())
    
    tmp = rbind(new2[1:nrow(prev2), ], prev2)
    ans = by(tmp, tmp[,1], function(x) names(x) [ sapply(x, function(x) length(unique(x))) != 1 ])
    ans[sapply(ans, length) > 0 ]
}
