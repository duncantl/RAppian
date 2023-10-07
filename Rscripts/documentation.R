x = xmlFiles()
xdocs = lapply(x,  xmlParse)
emp = as.data.frame(t(sapply(xdocs, function(x)
                              c(numEls = length(getNodeSet(x, "//namedTypedValue")),
                                notEmpty = length(getNodeSet(x, "//namedTypedValue[./description  and not(./description = '')]"))))))
emp$type = sapply(x, getType)
emp$name = sapply(x, getName)
emp$file = x

emp2 = emp[emp$numEls > 0,]

with(emp2, plot(numEls, notEmpty, ylim = range(numEls)))





map$descLen = nchar(map$description)
map$descNumWords = sapply(strsplit(map$description, "[[:space:][:punct:]]+"), length)

table(map$type, cut(nchar(map$description), c(0, 1, 10, 20, 40, 75, 100, 200, 300, Inf), include.lowest = TRUE))

table(map$type, cut(map$descNumWords, c(0, 1, seq(10, to = 100, by = 10)), include.lowest = TRUE))


library(ggplot2)

ggplot(map) + geom_density(aes(x = map$descNumWords, color = map$type))




tmp = cbind(map[, c("name", "type")], descLen = nchar(map$description ))[nchar(map$desc) < 11, ]
rownames(tmp) = NULL
tmp[order(tmp$descLen, tmp$type), ]



w = grepl("/*", map$code, fixed = TRUE)
table(w)

82/sum(!is.na(map$code))
# 82/589 = 14% have a comment at all.

m = gregexpr('(/\\*|\\*/)', map$code[w])
com = mapply(function(x, pos) {
          i = seq(1, length(pos) - 1, by = 2)
          substring(x, pos[i] + 2L, pos[i+1] - 1L)
    }, map$code[w], m)



com2 = uuname(unlist(com))
w2 = grepl("[:!]", com2)
table(nchar(com2[!w2]))

