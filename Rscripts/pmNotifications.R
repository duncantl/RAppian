# process model notifications.

# patches.xml throws the current code.
map = map[!is.na(map$type),]

pms = pms(map)

v = lapply(pms, pmNotifications, map)
pmn = do.call(rbind, v)
rownames(pmn) = pms

table(pmn$custom)

# Don't have custom settings
pmn[ ! pmn$custom, ]
# D EdocsUploadTest
# GM! High Level Process Model
# Never used.


table(pmn$notify.owner)
pmn[pmn$notify.owner, ]
# Now none. March24/
# √ EFRM LegacyFormSubmit
# √ EFRM LegacyGSReview
# √ EFRM Legacy Upload to Banner
# √ EFRM Legacy Generate Final PDF
# √ Exp Create Or Update Form Description


table(pmn$user)
table(pmn$recipients.exp)
table(pmn$user, pmn$recipients.exp)

table(user = pmn$user == "", recipient = pmn$recipients.exp == "")


# neither user or recipient expression.
pmn[pmn$user == "" & pmn$recipients.exp == "", ]
# The two above that use the default settings but which are never used


# Notifies user but not recipient expression
pmn[pmn$user != "" & pmn$recipients.exp == "", ]



w = pmn$user != ""
m = match(pmn$user[w], map$uuid)
# All NAs
