getAppianLogins =
function(asDf = TRUE, app.cookie = cookie("appian.cookie"), verbose = FALSE)
{
    u = "https://ucdavistest.appiancloud.com/suite/rest/a/applications/latest/app/admin/page/users"
# Cookie was last added and the necessary element
    js = getURLContent(u, httpheader = c(
                          "X-Appian-features" = "7ffceebc"
#                          "X-APPIAN-CSRF-TOKEN" = "0bf74a5b-a190-4bd9-b649-6252c160ccd6"
#                          "x-appian-suppress-www-authenticate" ="true",
#                          "X-Client-Mode" = "ADMIN",
#                          "X-Appian-Ui-State" = "stateful",
#                          "X-Appian-Initial-Form-Factor" = "DESKTOP",
#                          "X-Appian-Features-Extended" = "1dbff7f49dc1fffceebc"
                          ),
                   referer = "https://ucdavistest.appiancloud.com/suite/admin/page/users",
                   cookie = app.cookie,
                   useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/117.0",
                   verbose = verbose)

    ans = fromJSON(rawToChar(js))
    if(asDf) {
        tbl = ans$ui$centerPaneContent$contents[[1]]$contents[[1]]$columns[[1]]$contents[[2]]$columns
        mkTable(tbl)
    } else
        ans
}

mkTable =
function(tbl)    
{
#   ans = data.frame(ids = tbl[[2]]$data,
#                    emails = tbl[[5]]$data,
#                    first = tbl[[3]]$data,
#                    last = tbl[[4]]$data)

    flds = sapply(tbl, function(x) x$field)
    w = flds != ""
    ans = lapply(which(w), function(i) tbl[[i]]$data)
    names(ans) = flds[w]
    as.data.frame(ans)
}
