readDeploymentLog =
function(file, ll = readLines(file))
{
    g = split(ll, cumsum(w))
    g = g[sapply(g, length) > 1]

    names(g) = sapply(g, function(x) x[2])
    g = sapply(g, function(x) x[-1])
    g
}
