# JSESSIONID=5BD2EC307FB14A9015A135B26C4E9F7E; __appianCsrfToken=1b1500a9-b5e8-4e3c-92ac-ddb014155ddf; __appianMultipartCsrfToken=55690927-d722-4e66-8ac7-4ab2ba6a577d

# Don't have permission to download.
# + /suite/shared-logs/ucdavisdev-1/internal/
# + /suite/shared-logs/ucdavisdev-1/service-manager/
# + /suite/shared-logs/ucdavisdev-1/testlogs/
# + /suite/shared-logs/ucdavisdev-1/tomcat/

if(FALSE) {

    cookie = cookie("cookie")

    li = listLogs(cookie, TRUE)
    tc = grep("/tomcat-stdOut", li, value = TRUE)
    tc = tc[ !grepl("\\.gz$", tc) ]
    u = XML::getRelativeURL(tc, url = "https://gradsphere.ucdavis.edu/suite/logs")
    logs = downloadLogs(k, u)

#------    
    
    all = downloadLogs(cookie)

    li = listLogs(cookie, TRUE)
    tc = grep("/tomcat-stdOut", li, value = TRUE)
    tomcat = downloadLogs(cookie, tail(tc, 3))
    
    tc = grep("tomcat-stdOut.*2024-02-[12].$", li, value = TRUE)
    tomcat = downloadLogs(cookie, tc)
    tlogs = lapply(tomcat, readTomcatLog)

    num = sapply( tlogs, function(log) sum(sapply(log, function(x) sum(grepl("https://api.appian-test.ucdavis.edu/", x)))))

    err = lapply( tlogs, function(log) unlist(lapply(log, function(x) grep("https://api.appian-test.ucdavis.edu/", x, value = TRUE))))
}


downloadLogs =
function(cookie,
         docs = listLogs(cookie, url = url, relative = TRUE),
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

