# map comes from funs.R

if(exists("map")) {

    cons = do.call(rbind, lapply(map$file[map$type == "constant"], getConstantInfo))
    dup = duplicated(cons$value)
    d = cons[cons$value %in% cons$value[dup], ]
    tmp = split(d, d$value)

    table(sapply(tmp, nrow))

    # process model may legitimately be duplicated with different constants
    # Also, different enums can have the same values.
    #
    # The problems are probably the strings with the same values but different names.
    #  2x Your Candidacy application has been denied.
    #  4x Your Candidacy application has been returned for revision.
    #  2x Your QE Application has been Approved
    
    # And Integer?list -
    #   EFRM_INT_ATC_REQUEST_STAGE
    #   EFRM_INT_ATC_APPLICATION_REQUEST_STAGE

    # In other words,
    #  okay for different concepts to have the same value.
    #  not okay for same concept to have different names and the same value
    #     if change in one constant, the others won't be updated.
}
