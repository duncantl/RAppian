# parse(text = '"abc" & "xyz"')

if(FALSE)
    x = test.code$code[69]


StoR =
function(x, parse = FALSE, procModel = FALSE)
{
    # clean any trailing , and nonsense.
    x = gsub(",[[:space:]]*$", "", x)

    x = gsub("(![a-zA-Z0-9]+)\\.\\[", "\\1[", x)

    # Fix the "....""...." or "....."""
    x = fixAdjStrings(x)
    
    x = removeComments(x, procModel = procModel)

    # Do we need this given fixAdjStrings above?
    # Appears we don't 
    #    x = combineStringLiterals(x)
    
    x = mkList(x)

    x = gsub("^= *", "", x)

    # In some code, we may have a value: =ri!name. Remove the =
    # Check this doesn't break a lot of other things.
    x = gsub(": =ri!", ": ri!", x)
    x = gsub(':= #"', ': #"', x)
    # a named parameter followed by = then code
    x = gsub(': *= ', ': ', x)    

    if(procModel) {
        # This may be the format for a "is appended to" a variable
        # rather than is stored.
        x = gsub("&:", ":", x)

        # also, cases such as   <<<<<<<<<<<<<<<<
        # "legacyDetails[#\"urn:appian:record-field:v1:169a9a73-eb0e-4bea-b812-643499e8b123/939e934d-4088-4a5e-a1e6-70cb20b21e17\"]:=pv!requestId"
        # where there is a :=
        #????
        x = gsub(":=", ":", x)
    }
    

    # the order/when in this transformation process this step is done is important.
    # Can end up with !===
    x = changeOperators(x)

    x = gsub("(![a-zA-Z0-9]+)\\.(?= )", '\\1 & "." ', x, perl = TRUE)        

    x = gsub("(![a-zA-Z0-9]+)\\.(?=[^ ])", "\\1$", x, perl = TRUE)    

    x = escapeUUIDs(x)

    #  put ticks 
    #    x = gsub('([a-z]+)!([^:(),["[:space:] ]+)', "`\\1!\\2`", x)
    # Can't have  dom::name as when R sees dom::name = value
    # the parser throws an error.
    # So have to enclose in `` and in that case, no benefit to using :: versus !.
    x = gsub('([a-z]+|AC)!([a-zA-Z0-9]+)', "`\\1!\\2`", x)

    # change  'argName: '   to 'argName =' 
    x = gsub(": ", " = ", x)

    # R treats repeat() and if() specially so can't use those reserved words
    # so capitalize them.
    # (could do in one regex if the set of names grows.)
    x = gsub("if\\(", "IF\\(", x)
    x = gsub("repeat\\(", "Repeat(", x)

    # replace  ).name  such as ).data to )$name
    x = gsub("\\)\\.", ")$", x)

    # Fix _ https://docs.appian.com/suite/help/22.2/Expressions.html#advanced-evaluation

    # The _ in SAIL that is a partially evaluated call.
    x = gsub("= _([,)])", "= `_`\\1", x)
    x = gsub("\\(_([,)])", "(`_`\\1", x)    


    # to handle : = call
    x = gsub(" = == ", " == ", x)

    # to handle \x in strings
    x = gsub("\\\\", "\\\\\\\\", x)    


    # if end up with ====
    x = gsub("====", "==", x)
    
    if(parse) {
       ans =  tryCatch(parse(text = x, keep.source = FALSE),
                 error = function(e) {
#                     tryCatch(parse(text = fixStringConcat(x)),
#                         error = function(e) {
                           parse(text = collapseLines(x), keep.source = FALSE) # fixStringConcat(x)))
#                         })
                 })

      if(is.expression(ans) && length(ans) == 1)
          ans[[1]]
      else
          ans
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
    # Problem with "" in code such as
    # if(local!qualifier <> "", " - ", "")
    # where we end up removing the two ""
    # So we look for ' "",' or ' "")', i.e. "" that are clearly separated
    # from other elements because of the leading space and
    # replacing each "" with something that "can't" occur in the code
    # then doing the regular replacement to combine "...""..." into "......"
    # and then we reverse/undo the original replacement of "".
    # Works for now. Should make the original regexp smarter.
    x = gsub(' "",', ' "XXXXXXXXXXXXXXXXXX",', x)
    x = gsub(' ""\\)', ' "XXXXXXXXXXXXXXXXXX")', x)
    
    while(grepl('"([^"]+)""([^"]*)"', x)) {
        x = gsub('"([^"]+)""([^"]*)"', '"\\1\\2"', x)
    }

    gsub("XXXXXXXXXXXXXXXXXX", "", x)    
}


if(FALSE) {
    
combineStringLiterals =
    # Looks like we don't need this.
    # combineStringLiterals(' value: "[""" & ri!homeDepartmentName & """]"')
function(x)
{
    gsub('"([^"]*)""([^"]*)"', '"\\1\\2"', x)
}

fixStringConcat =
    #
    # Probably don't need this. fixAdjStrings is better.
    #
function(x)
{
    #    gsub('""', '', x)
    # replace "" with nothing but not if it is after ", " and also has , or ) after it as in
    #   foo(a, b, "") or
    #   foo(a, b, "", 1)
    gsub('(?<!, )""(?>![,)])', '', x, perl = TRUE)
}
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

    x = gsub('#"urn:appian:function:v1:fn:[^?]+\\?okey==([^"]+)"', "\\1", x)    
    
    x = gsub('#"(urn:appian:function:v1:a:update)"', "`#\\1`", x)
    x = gsub('#"([-0-9a-f_]+)"', "`#\\1`", x)    
}



mkList =
    #
    # Rather than having { expr, expr} in SAIL
    # we need  call( expr, expr) in R. So we'll use list( )
    #
    # √ should this be SBrace( rather than list(
    #
function(x)
{
#    gsub("\\{(.*?)\\}", "list(\\1)", x, perl = TRUE)
   x = gsub("\\{", "SBrace(", x, perl = TRUE)
   x = gsub("\\}", ")", x, perl = TRUE)        
}

changeOperators =
    #
    # Change <> to R's != and = to == for comparisons.
    #
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
    #
    # Show the code by displaying it line by line with line numbers
    # useful for debugging R parsing messages that give the line number.
    #
    # Start with the SAIL code. Can transform to R code via StoR (no parsing)
    # and then show the result.
    #
function(x, transform = TRUE, i = seq_len(length(y)))
{
    if(transform)
        x = StoR(x)
    
    y = strsplit(x, "\\n")[[1]]
    
    if(length(i) == 1)
        i = 1:i

    cat(paste(i, y[i]), sep = "\n")
}
