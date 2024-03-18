ll = system("egrep -r 'http.*appian' .", intern = TRUE)

names(ll) = seq(along.with = ll)
ll2 = gsub("^[^:]+:", "", ll)
ll2 = gsub('http://www.appian.com/ae/types/2009', 'XX', ll2)
ll3 = grep('http[^ ]+appian', ll2, value = TRUE)

fi = gsub(":.*", "", ll[ names(ll3) ])

w = grepl("\\.(properties|html)$", fi)

nm = sapply(fi[!w], function(x) tryCatch(getName(x), error = function(e) NA))
names(nm) = fi[!w]





#w = grepl('xmlns:a="http://www.appian.com/ae/types/2009">$', ll2)
#ll3 = ll2[!w]
#w2 = grepl('source="http://www.appian.com/ae/types/2009">$', ll3)
#ll4 = ll3[!w2]
