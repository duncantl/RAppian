\name{getName}
\alias{getName}
\alias{procName}
\alias{getType}
\alias{getDocType}
\alias{getDescription}
\alias{getDefinition}
\alias{getFolder}
\alias{getCode}
\alias{getUUID}
\alias{recordType}
\alias{ruleInputs}
\alias{siteInfo}
\alias{recordTypeInfo}
\alias{getConstantInfo}
\alias{interfaceInfo}
\alias{isEnvSpecific}
\alias{getRecordTypeCode}
\title{Get meta information from Appian object}
\description{
  These functions read the XML for an Appian object and return the
  meta data about that object such as
  the name, description, type, the UUID, which folder it is in.
  For record types, we can get a description of fields and types.
}
\usage{
getName(doc)
procName(doc)
getType(doc)
recordType(doc)
siteInfo(doc)
getCode(doc, noCode = NA)
getDefinition(doc, noCode = NA)
getUUID(doc)
ruleInputs(doc, map = NULL)
isEnvSpecific(doc)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doc}{the path to the XML file for the Appian object or the parsed XML document for that object.}
  \item{noCode}{the value to return for an XML document that contains no code content}
  \item{map}{a data.frame describing all of the objects in the exported application(s),
    typically created via \code{\link{mkSummary}}.}
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
