\name{StoR}
\alias{StoR}
\alias{rewriteCode}
\alias{findComments}
%\alias{mapName}
% \alias{mkCode}
\title{Convert SAIL code to R language objects}
\description{
  Functions to convert SAIL code from Appian objects
  to an equivalent representation as R language objects
  so we can analyze the contents of the code
  using R tools.
  These leverage the fact that the SAIL syntax is very close
  to R's and relatively few and simple transformations
  of the text of SAIL code makes it parseable as R code.
  These functions can convert the raw SAIL code
  to R and also resolve UUIDs in the code to symbolic
  names corresponding to record types, record fields,
  domain names (e.g., a!) to make the SAIL code
  similar to what is visible in the Appian designer interface.

  \code{StoR} is the primary function that transform the text of the SAIL
  code to R syntax. This optionally parses the result R code.

  \code{rewriteCode} is called on the result of \code{StoR} to
  transform the UUIDs in the code to human-readable references to
  other SAIL objects, e.g., the names of expression rules, record types,
  fields in record types. 
}
\usage{
StoR(x, parse = FALSE, procModel = FALSE)
rewriteCode(code, map, warn = FALSE, parse = TRUE) 
}
\arguments{
  \item{x}{the SAIL code as a character string/vector}
  \item{code}{the R language object (or string)}
  \item{parse}{a logical value indicating whether to parse the resulting
    R code and return an R language object}
  \item{procModel}{a logical value that indicates whether the SAIL code
    is the value of a process model custom output and so could contain a
    \code{&} in the form \code{var&:code} as part of an \code{is appended to} operation.}
  \item{map}{the data.frame describing all of the objects in the
    Appian application, typically obtained via call to \code{\link{mkSummary}}.
    If this is supplied, the result includes a column
    for the type of the variables providing the human-readable type name rather than the UUID.
  }
  \item{warn}{a logical value indicating whether to emit a warning
    if any of the raw identifiers cannot be mapped to regular names.}
}
\value{
  A character vector/string or an R language object.
}
\author{
Duncan Temple Lang
}
\seealso{
  \code{\link{xmlFiles}},   \code{\link{mkSummary}}
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
