progQEMemberInfo =
function(prog, inst = appianInstance())
{
   sql(sprintf('SELECT * FROM EFRM_COMMITTEE_MEMBERS_BUSINESS_RULE WHERE DEGREE_CODE = "%s"', prog),
       inst = inst)
}


studentDetailsForRequestId =
function(rid, cookie = dbCookie(),
         tbl = dbTable("EFRM_STUDENT_DETAILS", cookie, inst = inst),
         inst = appianInstance())    
{
    subset(tbl, REQUEST_ID == rid)
}


requestEmails =
function(rid, db = dbDump(, cooky, instance = inst), cooky = dbCookie(inst = inst),
         inst = appianInstance())
{

    tbl = if(missing(db))
              dbTable("EFRM_NOTIFICATION_LOG", cookie = cooky)
          else
              db$NOTIFICATION_LOG

    subset(tbl, REQUEST_ID == rid)
}
