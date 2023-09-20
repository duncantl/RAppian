findMissingUUIDs = 
function(rcodes, where = FALSE)
{
    mm1 = lapply(rcodes, ruses, TRUE)
    mm = unique(unlist(mm1))
    mm = mm[!grepl("SYSTEM_SYSRULES", mm)]
    rf = grepl("#urn:appian:record-field:v1", mm)

    urns = character()
    if(any(rf)) {
        urns = mm[rf]
        mm[rf] = gsub("#urn:appian:record-field:v1:([^/]+).*", "\\1", mm[rf])
    }

    ans = unique(mm)

    if(where)  {
        structure(lapply(ans, function(x) names(mm1)[ sapply(mm1, contains, x) ]), names = ans)
    } else
        ans
}
