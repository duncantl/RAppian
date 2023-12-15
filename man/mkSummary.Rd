\name{mkSummary}
\alias{mkSummary}
\title{Compute information about all objects in Appian app.}
\description{
}
\usage{
mkSummary(dir = ".", showOthers = FALSE, recTypes = recordTypeInfo, recRels = recordTypeRelationships, xf = xmlFiles(dir))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dir}{
%%     ~~Describe \code{dir} here~~
}
  \item{showOthers}{
%%     ~~Describe \code{showOthers} here~~
}
  \item{recTypes}{
%%     ~~Describe \code{recTypes} here~~
}
  \item{recRels}{
%%     ~~Describe \code{recRels} here~~
}
  \item{xf}{
%%     ~~Describe \code{xf} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (dir = ".", showOthers = FALSE, recTypes = recordTypeInfo, 
    recRels = recordTypeRelationships, xf = xmlFiles(dir)) 
{
    af = list.files(dir, recursive = TRUE, full = TRUE)
    if (showOthers) 
        print(dsort(table(tools::file_ext(setdiff(af, xf)))))
    info = data.frame(name = sapply(xf, getName), type = sapply(xf, 
        getDocType), uuid = gsub("\\.xml$", "", basename(xf)), 
        file = xf)
    info$description = sapply(xf, getDescription)
    info$qname = paste(info$type, info$name, sep = "!")
    rownames(info) = info$uuid
    if (is.function(recTypes)) {
        tmp = vector("list", nrow(info))
        w = info$type == "recordType"
        tmp[w] = lapply(info$file[w], recTypes)
        info$recordType = tmp
    }
    if (is.function(recRels)) {
        tmp = vector("list", nrow(info))
        w = info$type == "recordType"
        tmp[w] = lapply(info$file[w], recRels)
        info$recordRelationships = tmp
    }
    class(info) = c("AppianAppInfo", class(info))
    attr(info, "directory") = dir
    info
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
