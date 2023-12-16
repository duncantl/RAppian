\name{getName}
\alias{getName}
\alias{getType}
\alias{getDocType}
\alias{getDescription}
\alias{getFolder}
\alias{getCode}
\alias{getUUID}
\alias{recordType}
\alias{ruleInputs}
\alias{siteInfo}
\alias{recordTypeInfo}
\alias{getConstantInfo}
\alias{interfaceInfo}
\title{Get meta information from Appian object}
\description{
  These functions read the XML for an Appian object and return the
  meta data about that object such as
  the name, description, type, the UUID, which folder it is in.
  For record types, we can get a description of fields and types.
}
\usage{
getName(doc)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doc}{the path to the XML file for the Appian object or the parsed XML document for that object.}
}
\value{
}
%\references{}
\author{
  Duncan Temple Lang
}

\seealso{
\code{\link{procModelNodes}}, \code{\link{procModelVars}}
}
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
%\keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
