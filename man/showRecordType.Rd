\name{showRecordType}
\alias{showRecordType}
\alias{recordType2Markdown}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Create markdown description for a record type}
\description{
}
\usage{
showRecordType(doc, info = recordTypeInfo(doc), name = getName(doc))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doc}{the path to the XML file for the Appian record type object
      or the parsed XML document for that object.}
  \item{info}{the data.frame describing the record type}
  \item{name}{a character string giving the name of the record type.}
}
\value{
  A character vector that can be inserted into a markdown document.
}
%\references{}
\author{Duncan Temple Lang}
\seealso{
  \code{\link{recordTypeInfo}}
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
