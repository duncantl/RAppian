\name{usedBy}
\alias{usedBy}
\title{Compute which Appian object is called/used by which other Appian object}
\description{
  Similar to \code{\link{callGraph}} and \code{\link{uses}}.
}
\usage{
usedBy(code, domain = "interface", fun = mkUsesFun(domain))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{code}{a list of R language objects}
  \item{domain}{the prefix/domain of interest, e.g., "interface"}
  \item{fun}{}
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
function (code, domain = "interface", fun = mkUsesFun(domain)) 
{
    iuses = lapply(code, fun)
    ind = matrix(0, length(iuses), length(iuses), dimnames = list(names(code), 
        names(code)))
    for (i in names(iuses)) {
        tt = iuses[[i]]
        ind[i, names(tt)] = ind[i, names(tt)] + tt
    }
    ind
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
