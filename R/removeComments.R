removeComments =
function(x, procModel = FALSE)
{
    if(procModel)
        x = gsub(":/\\*.*?\\*/ *=", ": ", x, perl = FALSE)    
   gsub("/\\*.*?\\*/", "", x, perl = FALSE)
}

if(FALSE) {
test1 = c("/* TODO once DE approval is created. */\n\"NA\"",
          "ri!user = touser(\"sbdriver\")/* TODO: Use PRM to obtain Director of Advising */")

answer1 = c("\n\"NA\"", "ri!user = touser(\"sbdriver\")")
stopifnot(all(removeComments(test1) == answer1))

comseq = "ri!user = touser(\"sbdriver\") /*  some text */ + 1 /* and more */"

# Gets this wrong! Leaves the */
nested = "ri!user = touser(\"sbdriver\") /*  some text /* and another comment */ */ + 1 /* and more */"
}
