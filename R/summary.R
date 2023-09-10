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

    class(info) = "AppianAppInfo"
    info
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
    class(code2) = "AppianCodeInfo"

    code2
}


# Original version
# Show difference between this and the one below in the book.
function(a, b)
{
    vals = union(a$type, b$type)
    tt1 = table(factor(a$type, vals))
    tt2 = table(factor(b$type, vals))

    ans = data.frame(a = as.integer(tt1), b = as.integer(tt2), row.names = vals)
    ans[ order(ans$a, decreasing = TRUE), ]
}

compareTypeCounts =
    # Version that takes an arbitrary number of instances to compare and allows
    # us to use our own names
    # o = compareTypeCounts(test = test, dev = dev, dev0 = dev0)
function(...)
{
    args = list(...)
    # Get the union of all type values 
    vals = unique(unlist(lapply(args, `[[`, "type")))
    # Count the number in each instance, with 0s for unobserved types for an instance
    ans = lapply(args, function(x) as.integer(table(factor(x$type, vals))))
    ans = as.data.frame(ans, row.names = vals)
    # largest to smallest
    ans[ order(ans[[1]], decreasing = TRUE), ]
}
