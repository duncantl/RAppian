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

