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
mapFile(name, map, resolve = FALSE)
}
\arguments{
  \item{name}{a character string giving the name or UUID of the Appian object}
  \item{map}{a data.frame, typically computed via \code{\link{mkSummary}}}
  \item{resolve}{a logical value. If \code{TRUE} and the
    name corresponds to a constant, the function examines
    the value of the constant and if it is a UUID,
    resolves that. This is useful for
    getting the object to which a constant points/references, e.g.,
    a group or a process model.
  }
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
\examples{
\dontrun{
  # mapping the constant we get the file
  mapFile("EFRM_GROUP_GS_ASSOCIATE_DEANS", map)
  # and can check we get the correct value.
  getName(mapFile("EFRM_GROUP_GS_ASSOCIATE_DEANS", map))

  # However, if we resolve this, we get the actual group.
  getName(mapFile("EFRM_GROUP_GS_ASSOCIATE_DEANS", map, resolve = TRUE))
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
