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
    # Doesn't use rid currently.
    #
function(formDesc, loginId = NA, rid = NA, db = dbDump(), FUN = NULL)    
{
    rq = mergeRequestStuDetails(db)

        # It is the Advancement to Candidacy. The PhD Ca...Plan .. are not active.
    fids = getFormIDs(db, formDesc)

    if(is.na(loginId) && is.na(rid))
        return(subset(rq, E_FORM_ID %in% fids))

    if(!is.na(loginId)) {
        rec = subset(rq, E_FORM_ID %in% fids  & LOGIN_ID == loginId)
        if(nrow(rec) == 0)
            return(rec)
        
        rid = max(rec$REQUEST_ID)
    }    

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


mergeRequestStuDetails =
function(db)
{
    m = match(db$REQUEST_DETAILS$REQUEST_ID, db$STUDENT_DETAILS$REQUEST_ID)
    rq = cbind(db$REQUEST_DETAILS, db$STUDENT_DETAILS[m,])
}

getFormIDs =
function(db, name)
{
    db$EFORM[grep(name, db$EFORM$NAME), "E_FORM_ID"]
}
