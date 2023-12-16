\name{mapFile}
\alias{mapFile}
\alias{uuid2File}
\title{Map an Appian object name or UUID to the name of the corresponding XML file}
\description{
  This finds the path of the XML file
  for an Appian object using the \code{map}
  of the application objects
}
\usage{
mapFile(name, map)
}
\arguments{
  \item{name}{a character string giving the name or UUID of the Appian object}
  \item{map}{a data.frame, typically computed via \code{\link{mkSummary}}}
}
\value{
  A character string.
}
\author{
Duncan Temple Lang
}
\seealso{
   \code{\link{mkSummary}}
}
%\examples{}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
