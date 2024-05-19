# JSESSIONID=5BD2EC307FB14A9015A135B26C4E9F7E; __appianCsrfToken=1b1500a9-b5e8-4e3c-92ac-ddb014155ddf; __appianMultipartCsrfToken=55690927-d722-4e66-8ac7-4ab2ba6a577d

# Don't have permission to download.
# + /suite/shared-logs/ucdavisdev-1/internal/
# + /suite/shared-logs/ucdavisdev-1/service-manager/
# + /suite/shared-logs/ucdavisdev-1/testlogs/
# + /suite/shared-logs/ucdavisdev-1/tomcat/

if(FALSE) {
    li2 = listLogs(cookie, TRUE, url = "https://gradsphere.ucdavis.edu/suite/logs", filter = "/tomcat-stdOut.*[0-9]$")
}



if(FALSE) {

    cookie = cookie("cookie")

    li = listLogs(cookie, TRUE, url = "https://gradsphere.ucdavis.edu/suite/logs")
    tc = grep("/tomcat-stdOut", li, value = TRUE)
    tc = tc[ !grepl("\\.gz$", tc) ]
    u = XML::getRelativeURL(tc, "https://gradsphere.ucdavis.edu/suite/logs")
    logs = downloadLogs(cookie, tc)
    names(tc) = gsub("tomcat-stdOut.log.", "", basename(tc))

    logs2 = lapply(logs, function(x) strsplit(rawToChar(x), "\n")[[1]])

    sapply(logs2, length)


    ###
    cogn = lapply(logs2, function(x) grep("cognito:groups", x, value = TRUE))
    cogn2 = unlist(cogn)

    cogn3 = grep("Unable to find element cognito:groups in user data token", cogn2, value = TRUE, invert = TRUE)

    gr = gsub(".*'cognito:groups' = '\\[([^]]+)\\]'", "\\1", cogn3)
    groups = unlist(strsplit(gr, ", "))


    grep("ASSOCIATE_DEAN\\.", cogn2, value = TRUE)
    grep("DEAN\\.", cogn2, value = TRUE)

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
         docs = listLogs(cookie, url = url, relative = TRUE, ...),
         instance = appianInstance(),
         url = file.path(getHost(instance), "suite/logs"), ...)
{
   ans = lapply(docs, function(x)
                        tryCatch(getURLContent(x, binary = TRUE, cookie = cookie, followlocation = TRUE),
                                 error = function(e) NULL))
   names(ans) = basename(docs)

   
   ans
}




listLogs =
function(cookie, relative = FALSE, drop = TRUE,
         filter = character(),
         instance = appianInstance(),
         url = file.path(getHost(instance), "suite/logs"))
{
    tt = getURLContent(url, cookie = cookie, followlocation = TRUE)
    doc = htmlParse(tt)
    ll = getHTMLLinks(doc)


    if(length(filter)) 
        ll = grep(filter, ll, value = TRUE)


    if(drop)
        ll = ll[ !grepl("^[^/]", ll) ]    
    
    if(relative)
        getRelativeURL(ll, url)
    else
        ll
}

