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
        code = StoR(code, TRUE)[[1]]
   
    if(is.expression(code) && length(code) > 0)
        code = code[[1]]

    code
}
