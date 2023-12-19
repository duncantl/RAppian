findCalls =
function(file = "code.eg", 
         domain = "a!",
         pattern = paste0(domain, "[^\\[(),*:[:space:]]+"),
         k = paste(readLines(file, warn = FALSE), collapse = "\n"))
{
    if(!file.exists(file)) #  && grepl('localVariable', file))
        k = file
    
    regmatches(k, gregexpr(pattern, k)) # [[1]]
}

getDomains =
function(...)
{
  findCalls(...,  pattern =  "[A-Za-z0-9]+!")
}


findComments =
function(code)
{
   # https://stackoverflow.com/questions/13014947/regex-to-match-a-c-style-multiline-comment
    rx = "/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/"

    regmatches(code, gregexpr(rx, code)) # [[1]]
}


mkCode =
function(code)
{
    if(is.character(code))
        code = StoR(code, TRUE) # [[1]]
   
    if(is.expression(code) && length(code) == 1)
        code = code[[1]]

    code
}


localVarNames = varNames =
function(x, removeDomain = TRUE, error = TRUE)
{
    x = mkCode(x)
    if(!is.call(x) || ! (is.name(x[[1]]) && as.character(x[[1]]) == "a!localVariables")) {
        if(!error)
            return(character())
        
        stop("localVarNames expects a call to a!localVariables")
    }
    

    x =  x[ - c(1, length(x) )]
    vars = names(x)
    w = vars == ""
    if(any(w))
       vars[w] = sapply(x[w], as.character)

    if(removeDomain)
        gsub("^local!", "", vars)
    else
        vars
}

    

getCalls =
function(x, map = NULL)
{
    x = mkCode(x)

    funs = unique(getGlobals(x)$functions)
    if(!is.null(map)) 
        funs = funs[ funs %in% map$qname ]

    funs
}


saveTo =
    #
    #
function(x, asArg = TRUE)
{
    ans = findCallsTo(x, "a!save", parse = FALSE)
    if(length(ans)) {
        # ans = split(lapply(ans, function(x) x[[3]]), sapply(ans, function(x) as.character(x[[2]])))
        ans = split(lapply(ans, function(x) x[[3]]), sapply(ans, function(x) deparse(x[[2]])))        
    } else
        ans = list()

    if(asArg) {
        k = findCallsTo(x)
        w = sapply(k, function(x) any(c("saveInto", "selectSaveInto") %in% names(x) ))
        ans = c(ans, k[w])
    }
    
    ans
}



