mkSummary =
function(dir, showOthers = TRUE)
{
    xf = list.files(dir, recursive = TRUE, full = TRUE, pattern = "\\.xml$")
    af = list.files(dir, recursive = TRUE, full = TRUE)

    if(showOthers) 
        print(dsort(table(tools::file_ext(setdiff(af, xf)))))

    info = data.frame(name = sapply(xf, getName),
                      type = sapply(xf, getDocType),
                      file = xf)
}

mkCodeInfo =
function(dir = ".", xf = list.files(dir, recursive = TRUE, full = TRUE, pattern = "\\.xml$"))    
{
    code = lapply(xf, getCode)
    names(code) = xf
    code = code[sapply(code, length) > 0]

    code2 = data.frame(name = sapply(names(code), getName),
                       type = sapply(names(code), getDocType),
                       file = names(code),
                       code = code)
}
