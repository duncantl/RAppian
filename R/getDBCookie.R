getDBCookie =
    #
    # go to database and get the cookie to use with dbDump().
    #
    # driver is an RSelenium remoteDriver instance.
    # logged in to the Appian instance as a user who can access the database.
    #
function(driver,
         url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/sql&pos=0&db=Appian&table=EFRM_APPROVAL_DETAILS")
{
    driver$navigate(url)
    k2 = driver$getAllCookies()
    mkCookie(k2)
}

mkCookie =
function(x)
{
  paste(sapply(x, function(x) paste0(x$name, "=", x$value)), collapse = "; ")    
}
