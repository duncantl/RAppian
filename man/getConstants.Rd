\name{getConstants}
\alias{getConstants}
\title{Get information about all constant objects in application}
\description{
  This is a convenience function that describes all of the constant objects
  in an application via a single data.frame.
  The description provides the name, UUID, string of values, the type and the number of values.
}
\usage{
getConstants(map = mkSummary(dir), dir = ".")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{map}{a data.frame describing the objects in the exported application,
   typically created via \code{\link{mkSummary}}}
  \item{dir}{the directory for \code{\link{mkSummary}} if \code{map} is not provided.}
}
\value{
 A data.frame, with a row for each constant object containing
 \item{name}{its name}
 \item{uuid}{its UUID}
 \item{value}{a string with the values separated by ;}
 \item{type}{a string describing the type of the value(s)}
 \item{numValues}{the number of values in the constant if an array}
 \item{file}{the path to the XML file} 
}
%\references{}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{isEnvSpecific}}
}
\examples{
\dontrun{
  k = getConstants(map)
  w = sapply(k$file[k$numValues == 0], isEnvSpecific)
  table(w)
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
