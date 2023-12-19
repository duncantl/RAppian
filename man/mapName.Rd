\name{mapName}
\alias{mapName}
\title{Convert a raw Appian name to its human-readable form}
\description{

  Used in \code{\link{rewriteCode}}.
}
\usage{
mapName(x, map = mkSummary(...), ..., col = "qname", paths = TRUE)
}
\arguments{
  \item{x}{a character vector of raw names}
  \item{map}{the data.frame describing all of the objects in the
    Appian application, typically obtained via call to \code{\link{mkSummary}}.
    If this is supplied, the result includes a column
    for the type of the variables providing the human-readable type name rather than the UUID.
  }
  \item{\dots}{additional arguments passed to \code{\link{mkSummary}}}
  \item{col}{the name of the element/column in \code{map} to use
    when resolving URNs}
  \item{paths}{a logical value controlling how record type fields and relationships are returned}  
}
\value{
}

\author{
Duncan Temple Lang
}

\seealso{}
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
