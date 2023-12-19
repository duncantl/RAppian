\name{mapUUID}
\alias{mapUUID}
\alias{resolveURN}
\title{Get Appian object name corresponding to a UUID or urn}
\description{
  %XXX Fix this up. It was more for mapName()
  % Describe out and that we are just looking
  % for the corresponding elements of out.
  Given an Appian object's UUID or \code{#urn},
  \code{mapUUID} matches this to the corresponding object
  and returns the corresponding element of \code{out}.
  This is just an elaborate form of \code{match}
  that handles prefixes and suffixes such as \code{uuid...?list}.

  For convenience, \code{uuids} can be a data.frame and \code{out}
  the identifier for a column.  In this case, \code{mapUUID}
  uses \code{out}  to get the column and finds the population of
  uuids in the data.frame using \dQuote{uuid} as the column name.
}
\usage{
mapUUID(uuid, uuids, out) 
}
\arguments{
  \item{uuid}{a character vector}
  \item{uuids}{a character vector or a data.frame with a column named \dQuote{uuid}}
  \item{out}{if \code{uuids} is a data.frame with a column named
      \dQuote{uuids} and  \code{out}
    has length 1, then this is used to identify the column of
    \code{uuids} to be used for the vector of possible output values.
   }
}
\value{
}
\references{
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
