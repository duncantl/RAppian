dbCookie =
    #
    # suffix can be cookie or token
    #
function(fromFile = TRUE, inst = appianInstance(), setOpt = TRUE, suffix = "cookie")    
{
    ans = if(fromFile)
              NA        
          else
              getOption("DBCookie", NA)

    # XXX add check to see if it is expired.
    # If it is, don't return and read from the file.
    
    if(is.na(ans)) {
        fn = sprintf("db%s.%s",  inst, suffix)
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


dbToken = dbCookie
formals(dbToken)$suffix = "token"


getDBCookie =
    #
    # Previous version. And then there was also a selenium version that overrode this.
    #
    # The cookie is sufficiently short that it can be readily pasted into
    # the R session and it is sufficiently short-lived that it doesn't
    # necessarily warrant saving to a file for reuse in a different R session.
    #
function()
{
    mostRecentFile(c("~/appiandev.cookie", "~/appian.cookie", "appian.cookie"))
}

mostRecentFile =
function(files)
{
    ff = files
    w = file.exists(ff)
    if(!any(w))
        stop("cannot find Gradhub cookie")

    if(sum(w) == 1)
        ff = ff[w]
    else {
        info = file.info(ff[w])
        ff = ff[w][which.max(info$mtime)]
    }
    
    readLines(ff, warn = FALSE)[1]
}

