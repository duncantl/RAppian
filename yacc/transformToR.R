# parse(text = '"abc" & "xyz"')

if(FALSE)
    x = test.code$code[69]

if(FALSE) {
    # in the ExportedTest/ directory
    invisible(lapply(file.path("../../RAppian/yacc", c("removeComments.R", "transformToR.R")), source))    
    test.code = mkCodeInfo()
    input = test.code$code
    v = lapply(input, function(x) try(StoR(x, TRUE)))
    err0 = err
    err = sapply(v, inherits, 'try-error')
    msg = sapply(v[err], function(x) attr(x, "condition")$message)    
    table(err)
    which(!err0 & err)
      # going backwards

    dear = grepl("Dear", input)
    dearerr = grepl("Dear", input[err])    
    table(dear & err)
    table(dear, err)    
    # Now 4 with Dear that we couldn't parse.
    #
    
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

    # when this is done is important.
    # Can end up with !===
    x = changeOperators(x)    

    x = escapeUUIDs(x)
   
    x = gsub('([a-z]+)!([^:(),["[:space:] ]+)', "`\\1!\\2`", x)
    x = gsub(": ", " = ", x)
    x = gsub("if\\(", "IF\\(", x)

    x = gsub("\\)\\.", ")$", x)

    x = gsub("repeat\\(", "Repeat(", x)    

    # Fix _ https://docs.appian.com/suite/help/22.2/Expressions.html#advanced-evaluation

    x = gsub("= _([,)])", "= `_`\\1", x)
    x = gsub("\\(_([,)])", "(`_`\\1", x)    
   
    if(parse) {
        tryCatch(parse(text = x),
                 error = function(e) {
                     parse(text = fixStringConcat(x))
                     })
    }
    
    else
        x
}

fixStringConcat =
function(x)
{
    gsub('""', '', x)
}


escapeUUIDs =
function(x)
{
    # Was   x = gsub('#"([^"]+)"', "`\\1`", x)
    # but converted "ID #" to "ID `
    # Real problem is that # is within " "
    x = gsub('#"(SYSTEM_SYSRULES[^"]+)"', "`\\1`", x)
    x = gsub('#"(_[a-f]-|urn:appian:record-(type|field|relationship):v1:)([-0-9a-f_/]+)"', "`\\1\\2\\3`", x)
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
    # Was 
    # x = gsub("(?<!\\!)=", "==", x, perl = TRUE)
    # to account for != but have to also deal with
    # >= <=
    x = gsub("(?<![><!])=", "==", x, perl = TRUE)    
}


dp = 
function(x, i = seq_len(length(y)))
{
    y = strsplit(StoR(x), "\\n")[[1]]
    cat(paste(i, y[i]), sep = "\n")
}

