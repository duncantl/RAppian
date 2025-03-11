if(FALSE) {
    tst = c("nothing to do", "'abc'xyz", "Ellen Hartigan-O'Connor", "Ellen & Hartigan-O'Connor", "abc'",
             "Science & Technology", "Science & 'Technology' Studies")


    q = sprintf("SELECT %s;", foo(tst))
    ans = lapply(q, RAppian::sql, cookie, token)
    stopifnot(all(unlist(ans) == tst))
}


CharMap = c("'" = 39, "&" = 38)
CharMap[] = sprintf("CHAR(%d)", CharMap)

foo =
function(x, map = CharMap)
{

    m = gregexpr("['&]", x, perl = TRUE)
    by = regmatches(x, m)
    els = strsplit(x, "['&]")
    
    mapply(recomb, els, by, m, x, MoreArgs = list(map = map))
}

recomb =
function(els, sep, m, orig, map = CharMap)
{
    #    if(length(els) == 1)
    if(length(m) == 1 && m == -1)    
        return(sprintf("'%s'", els))


    cm = CharMap[sep]
    out = character( length(els) + length(sep) -1 )
    w = els == ""
    idx = seq(1, by = 2, length = length(els))
    out[idx] = sprintf("'%s'", els)
    out[ idx[ -length(idx) ] + 1] = cm
    if(m[1] == 1)
        out = out[-1]
    if(m[length(m)] == nchar(orig)) 
        out = c(out, cm)
    
    sprintf("CONCAT(%s)", paste(out, collapse = ", "))
}
