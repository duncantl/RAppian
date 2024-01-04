
literals = lapply(rcode2, CodeAnalysis:::findLiterals)
literals = literals[sapply(literals, length) > 0]

table(unlist(sapply(literals, function(x) sapply(x, class))))

nums = unlist(lapply(literals, function(x) x[sapply(x, is.numeric)]))
showCounts(dsort(table(nums)))

chars = unlist(lapply(literals, function(x) x[sapply(x, is.character)]))

summary(nchar(chars))

# The long ones. See if they start with a <
table(grepl("^<", chars[ nchar(chars)  > 1000 ]))
# They do and they are XML for Word.
# There are 45, and 36 are unique.
length(unique( chars[ nchar(chars)  > 1000 ]))
# So there are 9 repeats of what are very precise, complex strings.

# showCounts(dsort(table(chars)))


logs = unlist(lapply(literals, function(x) x[sapply(x, is.logical)]))
table(is.na(logs))
# All NAs.

table(map$type[ match(names(logs), map$name) ])

