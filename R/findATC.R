findStudentATC =
    #
    # student is either the SID, loginId or email (full or "xyz@")
    #
    # If token is specified, then we use a SQL query to get the rows of the joined table we want.
    # Otherwise, we get the entire DB dump. (Could get just the two tables, but still more than we need.)
    #
function(student, last = TRUE, token = NA, db = dbDump())    
{
    if(!is.na(token))
        ans = findStudentATC.sql(student, token = token)
    else {
        atcStu = mergeStuDetails(db, "ADVANCEMENT_TO_CANDIDACY_DETAILS")
        var = if(isSID(student))
                  "STUDENT_ID"
              else if(grepl("@", student))
                  "STUDENT_EMAIL"
              else
                  "LOGIN_ID"

        w = if(var == "STUDENT_EMAIL")
                grepl(student, atcStu[[var]])
            else
                atcStu[[var]] == student

        ans = atcStu[w,]
    }
    
    if(nrow(ans) > 1 && last)
        ans = ans[which.max(ans$REQUEST_ID), ]
    
    ans
}


findStudentATC.sql =
function(student, ...)
{
  qt = "SELECT * FROM EFRM_ADVANCEMENT_TO_CANDIDACY_DETAILS AS ATC,
                EFRM_STUDENT_DETAILS AS STU
        WHERE STU.REQUEST_ID = ATC.REQUEST_ID
        %s ;"

  and = if(grepl("@", student))
            sprintf("AND STU.STUDENT_EMAIL LIKE '%s'", student)
        else {
            var = if(isSID(student))
                      "STUDENT_ID"
                  else
                      "LOGIN_ID"

            sprintf("AND STU.%s = '%s'",
                    var, student)
        }
  
                
  qry = sprintf(qt, and)
  sql(qry, ...)
}


isSID =
function(x)
    grepl("^[0-9]{9}$", x)
