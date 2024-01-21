# The interface to the databases in appian is phpMyAdmin
# https://docs.phpmyadmin.net/en/latest/
# https://docs.phpmyadmin.net/en/latest/config.html

readDBDump =
    # file can be the actual JSON from dbDump()
function(file = mostRecent("127_0_0_1.*\\.json$", dir), dir = ".", removePrefix = TRUE, efrmOnly = TRUE,
         convertTimestamps = c(GMT = ""))
{
    j = RJSONIO::fromJSON(file)
    w = sapply(j, `[[`, "type") == "table"
    ids = sapply(j[w], `[[`, "name")

    tableNameRX = "^(EFRM|CMN|EXP|EDOCS)"
    if(is.character(efrmOnly)) {
        tableNameRX = sprintf("^(%s)", paste(efrmOnly, collapse = "|"))
        efrmOnly = TRUE
    }
    
    if(efrmOnly) {
        w2 = grepl(tableNameRX, ids)
        i = which(w)[w2]
        ids = ids[w2]
    } else
        i = which(w)


    if(removePrefix)
        ids = gsub("^(EFRM|CMN|RWM|EXP|[A-Z]+)_", "", ids)
    
    ans = structure(lapply(j[i], mkDBTable), names = ids)
    if(length(convertTimestamps) && !all(is.na(convertTimestamps)))
        ans = lapply(ans, cvtTimestamps, tz = convertTimestamps)

    ans
}

mkDBTable =
function(x)
{
    a = as.data.frame(do.call(rbind, x$data))
    a[] = lapply(a, cvtDBColumn)
    a
#    sapply(a, 
}

cvtDBColumn =
function(x)    
{
    if(is.list(x)) {
        w = sapply(x, is.null)
        if(all(sapply(x[!w], class) %in% c("logical", "numeric", "integer", "character"))) {
            x[w] = NA
            x = unlist(x)
        }
    }
    
    # simplify2array(x)
    type.convert(x, as.is = TRUE)
}

# Which columns across all the tables have any entries that start with 2023-
# table(unlist(sapply(d[sapply(d, nrow) > 0], function(df) names(df)[sapply(df, function(x) any(grepl("^2023-", x)))])))
# all the _ON$
# ACTUAL_EXAM_DATE
# COMPLETION_DATE
# DUE_DATE_TIME
# FINAL_EXAM_DATE
# QE_PASS_DATE
# SCHEDULED_QE_DATE
# TERM_END
# TERM_FILING_DEADLINE
# TERM_LAST_DAY_INSTRN
# TERM_START

cvtTimestamps =
function(df, cols = NA, tz = c(GMT = ""))
{
    if(is.na(cols)) 
        cols =  grep("_ON$", names(df))

    if(length(cols))
        df[cols] =  lapply(df[cols], cvtTimestampColumn, tz = tz)
    
    df
}

cvtTimestampColumn =
function(x, tz = c(GMT = ""))
{
   .POSIXct(as.POSIXct(x, tz = names(tz)), tz)
}




mostRecent
function(pattern, dir = "~/Downloads")
{
    info = file.info(list.files(dir, pattern = pattern, full.names = TRUE))
    rownames(info)[which.max(info$ctime)]
}
