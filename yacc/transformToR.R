# parse(text = '"abc" & "xyz"')

if(FALSE)
    x = test.code$code[69]


StoR =
function(x, parse = FALSE)
{
    # clean any trailing , and nonsense.
    x = gsub(",[[:space:]]*$", "", x)

    # Fix the "....""...." or "....."""
    x = fixAdjStrings(x)
    
    x = removeComments(x)
    x = combineStringLiterals(x)
    x = mkList(x)

    x = gsub("^= *", "", x)

    # when this is done is important.
    # Can end up with !===
    x = changeOperators(x)


    x = gsub("(![a-zA-Z0-9]+)\\.", "\\1$", x)    

    x = escapeUUIDs(x)

    #  put ticks 
    #    x = gsub('([a-z]+)!([^:(),["[:space:] ]+)', "`\\1!\\2`", x)
    x = gsub('([a-z]+)!([a-zA-Z0-9]+)', "`\\1!\\2`", x)    
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
                     tryCatch(parse(text = fixStringConcat(x)),
                         error = function(e) {
                           parse(text = collapseLines(fixStringConcat(x)))
                         })
                     })
    }
    
    else
        x
}

collapseLines =
function(x)
   gsub("\\n", "", x)



fixAdjStrings =
function(x)
{
    while(grepl('"([^"]+)""([^"]*)"', x)) {
        x = gsub('"([^"]+)""([^"]*)"', '"\\1\\2"', x)
    }
    x
}


fixStringConcat =
function(x)
{
    #    gsub('""', '', x)
    # replace "" with nothing but not if it is after ", " and also has , or ) after it as in
    #   foo(a, b, "") or
    #   foo(a, b, "", 1)
    gsub('(?<!, )""(?>![,)])', '', x, perl = TRUE)
}


escapeUUIDs =
function(x)
{
    # Was   x = gsub('#"([^"]+)"', "`\\1`", x)
    # but converted "ID #" to "ID `
    # Real problem is that # is within " "
    x = gsub('#"(SYSTEM_SYSRULES[^"]+)"', "`\\1`", x)
    x = gsub('#"(_[a-f]-|urn:appian:record-(type|field|relationship):v1:)([-0-9a-f_/]+)"', "`#\\1\\3`", x)
    # The extra = at okey== is because we have already transformed the =
    # ??? Whe should possible transform
    # #"urn:appian:function:v1:a:isusermemberofgroup?okey=a!isUserMemberOfGroup"
    # at the very start of the transformation (StoR)
    x = gsub('#"urn:appian:function:v1:a:isusermemberofgroup\\?okey==([^"]+)"', "\\1", x)    

    x = gsub('(#"urn:appian:function:v1:a:update")', "`#\\1`", x)
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
function(x, i = seq_len(length(y)), transform = TRUE)
{
    if(transform)
        x = StoR(x)
    
    y = strsplit(x, "\\n")[[1]]
    
    if(length(i) == 1)
        i = 1:i

    cat(paste(i, y[i]), sep = "\n")
}

