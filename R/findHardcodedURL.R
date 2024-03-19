# Reassign Task: Send Email
# Has  ucdavisdev.appiancloud hard coded as a value for a process parameter for sending the email.
# The file
#   content/_a-0000ea6a-ed23-8000-9bab-011c48011c48_175155/file.html
# is also very similar although it appears the body of the email is constructed
# programmatically and not from this file.

#
# The email Send E-Mail has a template named
#  EFRM Common Email Notification Template
# with ### parameter siteUrl which has the value pv!viewDetailLink
#
#

fixedURLs = 
function(dir = ".")
{    
    cmd = sprintf("egrep -r 'http.*appian' '%s'",  path.expand(dir))
    ll = system(cmd, intern = TRUE)

    names(ll) = seq(along.with = ll)
    ll2 = gsub("^[^:]+:", "", ll)
    ll2 = gsub('http://www.appian.com/ae/types/2009', 'XX', ll2)
    ll2 = gsub('https://docs.google.com/', 'GGG', ll2)    
    ll3 = grep('http[^ ]+appian', ll2, value = TRUE)

    fi = gsub(":.*", "", ll[ names(ll3) ])

    w = grepl("\\.(properties|html)$", fi)

    #nm = sapply(fi[!w], function(x) tryCatch(getName(x), error = function(e) NA))
    nm = sapply(fi[!w], getName)
    names(nm) = fi[!w]

    hc = data.frame(text = ll3, file = fi)
    hc$name[!w] = nm
    hc
}





#w = grepl('xmlns:a="http://www.appian.com/ae/types/2009">$', ll2)
#ll3 = ll2[!w]
#w2 = grepl('source="http://www.appian.com/ae/types/2009">$', ll3)
#ll4 = ll3[!w2]
