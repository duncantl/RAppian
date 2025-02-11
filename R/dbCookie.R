dbCookie =
    #
    # 
    #
function(inst = appianInstance(), setOpt = TRUE)    
{
    ans = getOption("DBCookie", NA)

    # XXX add check to see if it is expired.
    # If it is, don't return and read from the file.
    
    if(is.na(ans)) {
        fn = sprintf("db%s.cookie",  inst)
        fls = c(fn, file.path("~", fn))
        ex = file.exists(fls)
        if(!any(ex))
            stop("Cannot find ", fn)

        ans = cookie(fls[which(ex)[1]])
    }

    if(setOpt && !is.na(ans))
        options(DBCookie = ans)

    # XXX if expired, prompt caller to get cookie.
    ans
}
