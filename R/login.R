# DBMS  https://ucdavistest.appiancloud.com/database/index.php

login =
function(un , pw,
         info = getInitialCookie(u),
         u = "https://ucdavistest.appiancloud.com/suite/auth?appian_environment=tempo")
    # cookie = getInitialCookie(), token = getAppToken(cookie))
{
    args = list(un = un, pw = pw, `_spring_security_remember_me` = "on", "X-APPIAN-CSRF-TOKEN" = info["__appiancsrftoken"])

    con = getCurlHandle()
    postForm(u, .params = args,
             .opts = list(followlocation = TRUE, 
                          verbose = TRUE,
                          referer = "https://ucdavistest.appiancloud.com/suite/portal/login.jsp",
                          cookie = info["cookie"]),
             curl = con, style = "post")

    con
}

getAppToken =
function(x)
{
    parseCookie(x)[" __appianCsrfToken"]
}

parseCookie =
function(x)
{        
    e =  strsplit(x, "[;=]")[[1]]
    i = seq(1, by = 2, length = length(e)/2)
    structure( e[i + 1L], names = e[i])
}



getInitialCookie =
function(u = "https://ucdavistest.appiancloud.com/suite/portal/login.jsp")
{
    z = getURLContent(u, header = TRUE)
    h = z$header
    k = h[names(h) == "set-cookie" & grepl("JSESSIONID", h)]

    token = h["__appiancsrftoken"]
    jsession = parseCookie(k)
    c(token, jsession[1],
      cookie = sprintf("JSESSIONID=%s; __appianCsrfToken=%s", jsession["JSESSIONID"], token),
      use.names = TRUE)
}
