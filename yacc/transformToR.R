# parse(text = '"abc" & "xyz"')

if(FALSE)
    x = test.code$code[69]

if(FALSE) {
    # in the ExportedTest/ directory
    invisible(lapply(file.path("../../RAppian/yacc", c("removeComments.R", "transformToR.R")), source))    
    test.code = mkCodeInfo()
    input = test.code$code
    v = lapply(input, function(x) try(StoR(x, TRUE)))
    err = sapply(v, inherits, 'try-error')
    table(err)

    msg = sapply(v[err], function(x) attr(x, "condition")$message)

    length(unique(gsub("^\\<text\\>:[0-9]+:[0-9]+: ", "", msg)))

    length(unique(gsub("^\\<text\\>:[0-9]+:[0-9]+: ([^ ]+) .*", "\\1", msg)))    
}


StoR =
function(x, parse = FALSE)
{
    x = removeComments(x)
    x = combineStringLiterals(x)
    x = mkList(x)

    x = gsub("^= *", "", x)
    

    x = escapeUUIDs(x)
   
    x = gsub('([a-z]+)!([^:(),["[:space:] ]+)', "`\\1!\\2`", x)
    x = gsub(": ", " = ", x)
    x = gsub("if\\(", "IF\\(", x)

    x = gsub("\\)\\.", ")$", x)

    # when this is done is important.
    # Can end up with !===
    x = changeOperators(x)

   
    if(parse)
        parse(text = x)
    else
        x
}

escapeUUIDs =
function(x)
{
    # Was   x = gsub('#"([^"]+)"', "`\\1`", x)
    # but converted "ID #" to "ID `
    # Real problem is that # is within " "
    x = gsub('#"(SYSTEM_SYSRULES[^"]+)"', "`\\1`", x)
    x = gsub('#"(_[a-f]-|urn:appian:record-(type|field):v1:)([-0-9a-f_/]+)"', "`\\1\\2\\3`", x)
    x = gsub('#"([-0-9a-f_]+)"', "`\\1`", x)    
}


combineStringLiterals =
    # combineStringLiterals(' value: "[""" & ri!homeDepartmentName & """]"')
function(x)
{
    gsub('"([^"]*)""([^"]*)"', '"\\1\\2"', x)
}

mkList =
function(x)
{
#    gsub("\\{(.*?)\\}", "list(\\1)", x, perl = TRUE)
   x = gsub("\\{", "list(", x, perl = TRUE)
   x = gsub("\\}", ")", x, perl = TRUE)        
}

changeOperators =
function(x)    
{
#    x = gsub("\\<\\>", "!=", x)
    x = gsub("<>", "!=", x, fixed = TRUE)
    x = gsub("(?<!\\!)=", "==", x, perl = TRUE)    
}



