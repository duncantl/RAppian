xmlFiles =
function(dir = ".")    
     list.files(dir, recursive = TRUE, full = TRUE, pattern = "\\.xml$")

mkSummary = mkAppInfo =
    #
    # A data.frame with columns
    # name
    # type
    # uuid
    # file
    # recordType - a list with a data.frame for elements corresponding to type == recordType
    #    This is computed via recTypes for each recordType file.
    #
    #
    #
    # Maybe faster to parse each document and then
    # call getName, getDocType, etc. on the preparsed documents.
    #
function(dir = ".", showOthers = FALSE, recTypes = recordTypeInfo, recRels = recordTypeRelationships)
{
    xf = xmlFiles()
    af = list.files(dir, recursive = TRUE, full = TRUE)

    if(showOthers) 
        print(dsort(table(tools::file_ext(setdiff(af, xf)))))

    info = data.frame(name = sapply(xf, getName),
                      type = sapply(xf, getDocType),
#                     uuid = sapply(xf, getUUID),
                      uuid = gsub("\\.xml$", "", basename(xf)),
                      file = xf)

    info$qname = paste(info$type, info$name, sep = "!")
    
    # duplicate name values so can't use as rownames()
    #    rownames(info) = info$name
    rownames(info) = info$uuid


    if(is.function(recTypes)) {
        tmp = vector("list", nrow(info))
        w = info$type == "recordType"
        tmp[w] = lapply(info$file[w], recTypes)
        info$recordType = tmp
    }

    if(is.function(recRels)) {
        tmp = vector("list", nrow(info))
        w = info$type == "recordType"
        tmp[w] = lapply(info$file[w], recRels)
        info$recordRelationships = tmp
    }    
    
    class(info) = c("AppianAppInfo", class(info))

    # This allows us to identify the location of the application files.
    # Originally intended to be use to find files, but  the values in the file column have the full path.
    attr(info, "directory") = dir
    info
}

mkCodeInfo =
function(dir = ".", xf = xmlFiles(dir))
{
    if(all(grepl("^\\./", xf)))
        xf = substring(xf, 3)
    
    code = sapply(xf, getCode)
    names(code) = xf

    code = code[sapply(code, length) > 0]
    names = sapply(names(code), getName)
    code2 = data.frame(name = names,
                       type = sapply(names(code), getDocType),
                       # or use sapply(names(code), getUUID)
                       uuid = gsub("\\.xml$", "", basename(names(code))),
                       file = names(code),
                       code = as.character(code))
    
    class(code2) = c("AppianCodeInfo", class(code2))

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
