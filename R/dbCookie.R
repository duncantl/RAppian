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

        fl = fls[which(ex)[1]]
        delta = difftime(Sys.time(), file.info(fl)[1, "mtime"], "mins")
        if(delta > 23)
            warning("cookie has probably expired")
        
        ans = cookie(fl)
    }

    if(setOpt && !is.na(ans))
        options(DBCookie = ans)

    # XXX if expired, prompt caller to get cookie.
    ans
}
