\name{genRecordTypeCode}
\alias{genRecordTypeCode}
\title{Create SAIL expression rule to create/update an instance of a given record type}
\description{
  Rather than manually writing the code to set or update
  all of the fields for a new record type,
  we generate the code.
  Unfortunately, one still has to add the rule inputs to the expression rule
  via the GUI.
}
\usage{
genRecordTypeCode(name = "EFRM Task Log", map, rhs = mkDefaultValue)
}
\arguments{
  \item{name}{the name of the Record Type}
  \item{map}{the data.frame from \code{\link{mkSummary}} for the entire application/package.}
  \item{rhs}{a function to compute the values for each each field.
    This allows one to customize the code to set the values of the rule inputs
    or use the value in an existing template/default object.}
}
\value{
  A character vector.
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
\keyword{programming}
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
\concept{metaprogramming}
