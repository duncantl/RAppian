# JSESSIONID=5BD2EC307FB14A9015A135B26C4E9F7E; __appianCsrfToken=1b1500a9-b5e8-4e3c-92ac-ddb014155ddf; __appianMultipartCsrfToken=55690927-d722-4e66-8ac7-4ab2ba6a577d

# Don't have permission to download.
# + /suite/shared-logs/ucdavisdev-1/internal/
# + /suite/shared-logs/ucdavisdev-1/service-manager/
# + /suite/shared-logs/ucdavisdev-1/testlogs/
# + /suite/shared-logs/ucdavisdev-1/tomcat/

if(FALSE) {

    all = downloadLogs(cookie)

    
    li = listLogs(cookie, TRUE)
    tc = grep("/tomcat", li, value = TRUE)
    tomcat = downloadLogs(cookie, tail(tc, 3))
}


downloadLogs =
function(cookie,
         docs = listLogs(cookie, url, relative = TRUE),
         url = "https://ucdavisdev.appiancloud.com/suite/logs")    
{
   ans = lapply(docs, function(x)
                        tryCatch(getURLContent(x, binary = TRUE, cookie = cookie, followlocation = TRUE),
                                 error = function(e) NULL))
   names(ans) = basename(docs)
   ans
}

listLogs =
function(cookie, relative = FALSE, drop = TRUE, url = "https://ucdavisdev.appiancloud.com/suite/logs")    
{
    tt = getURLContent(url, cookie = cookie, followlocation = TRUE)
    doc = htmlParse(tt)
    ll = getHTMLLinks(doc)
    if(drop)
        ll = ll[ !grepl("^[^/]", ll) ]
    
    if(relative)
        getRelativeURL(ll, url)
    else
        ll
}

