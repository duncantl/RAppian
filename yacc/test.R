    # in the ExportedTest/ directory
invisible(lapply(file.path("../../RAppian/yacc", c("removeComments.R", "transformToR.R")), source))    
if(!exists("test.code"))
    test.code = mkCodeInfo()

if(!exists('input'))
    input = test.code$code

v = lapply(input, function(x) try(StoR(x, TRUE)))
if(exists("err"))
    err0 = err

err = sapply(v, inherits, 'try-error')
msg = trimws(sapply(v[err], function(x) attr(x, "condition")$message))
print(table(err))

if(exists("err0"))
          # going backwards
    which(!err0 & err)



if(FALSE) {
dear = grepl("Dear", input)
dearerr = grepl("Dear", input[err])    
table(dear & err)
table(dear, err)    
    # Now 4 with Dear that we couldn't parse.
    #
   

length(unique(gsub("^\\<text\\>:[0-9]+:[0-9]+: ", "", msg)))

length(unique(gsub("^\\<text\\>:[0-9]+:[0-9]+: ([^ ]+) .*", "\\1", msg)))
}
