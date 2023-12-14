if(!exists("rcode2", globalenv(), inherits = FALSE))
    source("basics.R")
    
k = rcode2$EFRM_getWorkflowFormRelatedInformationBasedOnVisibility$"local!allFormMap"

wkflows = lapply(k[-1], function(x) x[ - 1])
names(wkflows) = sapply(wkflows, function(x) x[[1]])

 # remove the SBrace
forms = lapply(wkflows, function(x) x$forms[-1])
f2 = unlist(lapply(forms, as.list))

# Breaks now because of the constant for the legacy forms workflow name.
info = data.frame(name = sapply(f2, function(x) x$name),
                  processModel = sapply(f2, function(x) getName(x$processModel))
                  )

info$procModel = sapply(info$processModel, function(x) getName(uuid2File(getConstantInfo(map$file[x == map$name])$value, dir)))
info$params = lapply(f2, function(x) names(x$processParameters)[-1])

# Too recursive.
#findCallsTo(k, "a!map", parse = FALSE)

################
