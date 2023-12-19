\name{usedBy}
\alias{usedBy}
\title{Compute which Appian object is called/used by which other Appian object}
\description{
  Similar to \code{\link{callGraph}}.
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
\value{
  Returns a square incidence matrix representing the direct connections
  of what (row) calls what (column)
}
\author{
Duncan Temple Lang
}
\seealso{
}
\examples{
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
