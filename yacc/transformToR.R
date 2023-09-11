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
    
    x = changeOperators(x)
    
    x = gsub('#"([^"]+)"', "`\\1`", x)
    x = gsub('([a-z]+)!([^:(),["[:space:] ]+)', "`\\1!\\2`", x)
    x = gsub(": ", " = ", x)
    x = gsub("if\\(", "IF\\(", x)
    if(parse)
        parse(text = x)
    else
        x
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
   gsub("\\{(.*?)\\}", "list(\\1)", x, perl = TRUE)
}

changeOperators =
function(x)    
{
    x = gsub("\\<\\>", "!=", x)
    gsub("=", "==", x)
}



