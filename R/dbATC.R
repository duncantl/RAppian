# Find esbae's most recent ATC form.
# Move to RAppian/examples/
# or make a function in RAppian

getATC =
function(loginId = NA, rid = NA, db = dbDump())
{    
    m = match(db$REQUEST_DETAILS$REQUEST_ID, db$STUDENT_DETAILS$REQUEST_ID)
    rq = cbind(db$REQUEST_DETAILS, db$STUDENT_DETAILS[m,])

    # It is the Advancement to Candidacy. The PhD Ca...Plan .. are not active.
    fids = db$EFORM[grep("Advancement to Candidacy", db$EFORM$NAME), "E_FORM_ID"]

    if(missing(loginId) && missing(rid))
        return(subset(rq, E_FORM_ID %in% fids))

    if(!missing(loginId)) {
        atc = subset(rq, E_FORM_ID %in% fids  & LOGIN_ID == "esbae")
        rid = max(atc$REQUEST_ID)
    }    

    list(rid = rid, 
         atc = subset(db$ADVANCEMENT, REQUEST_ID == rid),
         members = subset(db$COMMITTEE_MEMBERS, REQUEST_ID == rid),
         student = subset(db$STUDENT_DETAILS, REQUEST_ID == rid)
         )
}
