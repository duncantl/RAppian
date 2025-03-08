# Find esbae's most recent ATC form.
# Move to RAppian/examples/
# or make a function in RAppian


getATC =
    #
    #  getATC(rid = 1600, db = db)
    #
    #
function(loginId = NA, rid = NA, db = dbDump())
{
    desc = "Advancement to Candidacy"

    fun = function(rid, db) {
              list(atc = subset(db$ADVANCEMENT, REQUEST_ID == rid),
                   members = subset(db$COMMITTEE_MEMBERS, REQUEST_ID == rid)
                   )
          }
    
    getRequestForFormType(desc, loginId, rid, db, FUN = fun)
}

getRequestForFormType =
    #
    #
function(formDesc, loginId = NA, rid = NA, db = dbDump(), FUN = NULL, all = FALSE)    
{
    rq = mergeRequestStuDetails(db)

        # It is the Advancement to Candidacy. The PhD Ca...Plan .. are not active.
    fids = getFormIDs(db, formDesc)

    if(is.na(loginId) && is.na(rid))
        return(subset(rq, E_FORM_ID %in% fids))

    if(is.na(rid) && !is.na(loginId)) {
        rec = subset(rq, E_FORM_ID %in% fids  & LOGIN_ID == loginId)
        if(nrow(rec) == 0)
            return(NULL)

        if(!all)
            rid = max(rec$REQUEST_ID)
    }

    #XXX figure out what to do if all = TRUE

    ans = list(rid = rid,
               student = subset(db$STUDENT_DETAILS, REQUEST_ID == rid)
               )
    if(is.function(FUN))
        ans = c(ans, FUN(rid, db))

    ans
}


getQEApp =
function(loginId = NA, rid = NA, db = dbDump(, cooky, instance = inst), cooky = dbCookie(inst = inst),
         inst = appianInstance())    
{
    fun = function(rid, db) {
        list(qeApp = subset(db$QE_DETAILS, REQUEST_ID == rid),
             members = subset(db$COMMITTEE_MEMBERS, REQUEST_ID == rid)
            )        
    }
    
    getRequestForFormType("Qualifying Examination Application", loginId, rid, db, FUN = fun)
}


getQEReport =
function(loginId = NA, rid = NA, db = dbDump(, cooky, instance = inst), cooky = dbCookie(inst = inst),
         inst = appianInstance())    
{
    fun = function(rid, db) {
        list(qeApp = subset(db$QE_REPORT, REQUEST_ID == rid),
             members = subset(db$COMMITTEE_MEMBERS, REQUEST_ID == rid)
            )        
    }
    
    getRequestForFormType("Qualifying Examination Report", loginId, rid, db, FUN = fun)
}



getFiling =
function(loginId = NA, rid = NA, db = dbDump(, cooky, instance = inst), cooky = dbCookie(inst = inst),
         inst = appianInstance())    
{
    fun = function(rid, db) {
        list(filing = subset(db$FILING_DETAILS, REQUEST_ID == rid),
             members = subset(db$COMMITTEE_MEMBERS, REQUEST_ID == rid)
            )        
    }
    
    getRequestForFormType("Filing Process", loginId, rid, db, FUN = fun)
}


mergeRequestStuDetails =
function(db)
{
    m = match(db$REQUEST_DETAILS$REQUEST_ID, db$STUDENT_DETAILS$REQUEST_ID)
    rq = cbind(db$REQUEST_DETAILS, db$STUDENT_DETAILS[m,])
}


mergeStuDetails =
    # Sligtly more general version of mergeRequestStuDetails()
    # in that can specify a different table name.
    # Can set mergeRequestStuDetails() to this.
function(db, with = "REQUEST_DETAILS")
{
    m = match(db[[with]]$REQUEST_ID, db$STUDENT_DETAILS$REQUEST_ID)
    rq = cbind(db[[with]], db$STUDENT_DETAILS[m,])
}



getFormIDs =
function(db, name)
{
    db$EFORM[grep(name, db$EFORM$NAME), "E_FORM_ID"]
}
