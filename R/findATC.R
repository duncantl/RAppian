findStudentATC =
    #
    # student is either the SID, loginId or email (full or "xyz@")
    #
function(student, last = TRUE, db = dbDump())    
{
    atcStu = mergeStuDetails(db, "ADVANCEMENT_TO_CANDIDACY_DETAILS")
    var = if(grepl("^[0-9]{9}$", student))
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

    if(nrow(ans) > 1 && last)
        ans = ans[which.max(ans$REQUEST_ID), ]
    
    ans
}
