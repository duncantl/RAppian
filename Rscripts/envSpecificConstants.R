source("basics.R")

w = map$type == "constant"
y = sapply(map$file[w], isEnvSpecific)

z = data.frame(name = map$name[w][y],
               description = sapply(map$file[w][y], getDescription), row.names = NULL)

