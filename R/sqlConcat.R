if(FALSE) {
    library(RAppian)
    tst = c("nothing to do", "'abc'xyz", "Ellen Hartigan-O'Connor", "Ellen & Hartigan-O'Connor", "abc'",
            "Science & Technology", "Science & 'Technology' Studies",
            "some extra $ and # characters!",
            "some extra $ and # characters!&'",
            "x[123]"
            )

    q = sprintf("SELECT %s;", sqlQuote(tst))
    ans = lapply(q, RAppian::sql, cookie, token)
    stopifnot(all(unlist(ans) == tst))
}

if(FALSE) {

    
    chars = setdiff(names(CharMap), c("\\", "/", "␠"))
    x = c(letters, LETTERS, chars, " ", ".", ";", ":")
    ph = replicate(100, paste(sample(x, 60, replace = TRUE), collapse = ''))

    q2 = sprintf("SELECT %s;", sqlQuote(ph))
    ans2 = lapply(q2, \(x) try(RAppian::sql(x, cookie, token)))
    err = sapply(ans2, inherits, 'try-error')
    table(err)
    w2 = unlist(ans2[!err]) == ph[!err]
    w3 = grepl("(^ | $|␠)", ph[!err], perl = TRUE)
    stopifnot(all(w2 | w3))

    cat(ph[!err][!w2], sep = "\n")
    table( w3[!w2])

    # MariaDB is converting th sp to an actual space.
    w4 = gsub("␠", " ", ph[!err][!w2]) == unlist(ans2[!err][!w2])

    table(w4)

    # Reason they are not all the same is the DB trimming the string and the original ph having leading/trailing white space.
    z = cbind(unname(ph[!err][!w2][!w4]), unname(unlist(ans2[!err][!w2][!w4])))
    
    # This is the one that did not have a \ and is not the same.
    # #31
    # original =       'qq:ISBv;k,Y|]]{i>e}'qp.R:bc^TP*RIO_[zuHTDh`.;?P;k]^caZiIE=J '    
    # from SQL query = 'qq:ISBv;k,Y|]]{i>e}'qp.R:bc^TP*RIO_[zuHTDh`.;?P;k]^caZiIE=J'
    #
    #  Extra space at the end is removed by
    # Really do want the space from the URL table of character codes.
    # Only reason to remove it was emacs. But newly installed emacs.

    # Now the only 2 that don't match have a space at the start and the end.

}


# https://www.ascii-code.com/characters/punctuation-and-symbols
if(FALSE) {
library(XML)
doc =htmlParse(readLines("https://www.ascii-code.com/characters/punctuation-and-symbols"))
tbl = readHTMLTable(doc, which = 1)
CharMap = structure(as.integer(tbl[[1]]), names = tbl[[3]])[-1]  # sp
dput(CharMap)

dput(unname(CharMap))
dput(names(CharMap))
}

CharMap = structure(c(32L, 33L, 34L, 35L, 36L, 37L, 38L, 39L, 40L, 41L, 42L, 43L, 
                       44L, 45L, 46L, 47L, 58L, 59L, 60L, 61L, 62L, 63L, 64L, 91L, 92L, 
                       93L, 94L, 95L, 96L, 123L, 124L, 125L, 126L),
                      names = c("␠", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", 
                                ",", "-", ".", "/", ":", ";", "", "=", ">", "?", "@", "[", "\\", 
                                "]", "^", "_", "`", "{", "|", "}", "~"))
# Omit the sp(ace)
# CharMap = CharMap[-1]


# dput messes up the names if we dput(CharMap)
if(FALSE) {
CharMap = structure(
            c(33L, 34L, 35L, 36L, 37L, 38L, 39L, 40L, 41L, 42L, 43L, 44L, 
              45L, 46L, 47L, 58L, 59L, 60L, 61L, 62L, 63L, 64L, 91L, 92L, 93L, 
              94L, 95L, 96L, 123L, 124L, 125L, 126L),
    names = c("!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", 
              "-", ".", "/", ":", ";", "", "=", ">", "?", "@", "[", "\\", "]", 
              "^", "_", "`", "{", "|", "}", "~")
)
}


# CharMap = c("'" = 39, "&" = 38, "!" = 33, '"' = 34, "$" = 36, "#" = 35, "?" = 63)
# c( `!` = 33L, `"` = 34L, `#` = 35L, `$` = 36L, `%` = 37L, 
#  `&` = 38L, `'` = 39L, `(` = 40L, `)` = 41L, `*` = 42L, `+` = 43L, 
#  `,` = 44L, `-` = 45L, . = 46L, `/` = 47L, `:` = 58L, `;` = 59L, 
#  60L, `=` = 61L, `>` = 62L, `?` = 63L, `@` = 64L, `[` = 91L, `\` = 92L, 
#  `]` = 93L, `^` = 94L, `_` = 95L, `\\`` = 96L, `{` = 123L, `|` = 124L, 
#  `}` = 125L, `~` = 126L)
CharMap[] = sprintf("CHAR(%d)", CharMap)

sqlQuote =
function(x, map = CharMap)
{
    # omitting \ and \\ from CharMap
    rx =  "([]}{()'&#$!%@;:,.␠/=>_|`^+*?~-]|\\])"
    m = gregexpr(rx, x)#, perl = TRUE)
    by = regmatches(x, m)
    els = strsplit(x, rx)
    
    mapply(recomb, els, by, m, x, MoreArgs = list(map = map))
}

recomb =
function(els, sep, m, orig, map = CharMap)
{
    if(length(m) == 1 && m == -1)    
        return(sprintf("'%s'", els))

    cm = CharMap[sep]
    out = character( length(els) + length(sep) -1 )
    w = els == ""
    idx = seq(1, by = 2, length = length(els))
    out[idx] = sprintf("'%s'", els)
    #    out[ idx[ -length(idx) ] + 1] = cm
#    browser()
    out[ idx[ seq(along.with = cm) ] + 1] = cm    
    if(m[1] == 1)
        out = out[-1]
#    if(m[length(m)] == nchar(orig)) 
#        out = c(out, cm)
    
    sprintf("CONCAT(%s)", paste(out, collapse = ", "))
}
