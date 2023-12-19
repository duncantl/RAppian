dsort =
function(x, ...)
  sort(x, ..., decreasing = TRUE)

contains = 
function(x, what)
{
   what %in% x
}

mostRecent =
function(pattern, dir = "~/Downloads")
{
    info = file.info(list.files(dir, pattern = pattern, full.names = TRUE))
    rownames(info)[which.max(info$ctime)]
}
