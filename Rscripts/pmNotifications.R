# process model notifications.
pms = pms(map)
v = lapply(pms, pmNotifications, map)
pmn = do.call(rbind, v)
rownames(pmn) = pms

pmn[ ! pmn$custom, ]
# D EdocsUploadTest
# GM! High Level Process Model

pmn[pmn$notify.owner, ]
# EFRM LegacyFormSubmit
# EFRM LegacyGSReview
# EFRM Legacy Upload to Banner
# EFRM Legacy Generate Final PDF
# Exp Create Or Update Form Description


table(pmn$user)
table(pmn$recipients.exp)
table(pmn$user, pmn$recipients.exp)

table(user = pmn$user == "", recipient = pmn$recipients.exp == "")

pmn[pmn$user == "" & pmn$recipients.exp == "", ]


