\name{localVarNames}
\alias{localVarNames}
\title{Get names of all local variables from a SAIL \code{a!localVariables} call}
\description{
  This extracts the names of the local variables declared or defined in
  a SAIL \code{a!localVariables} call.
}
\usage{
localVarNames(x, removeDomain = TRUE, error = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{the R call object representing the \code{a!localVariables} call}
  \item{removeDomain}{a logical value controlling whether
    to remove the \code{local!} prefix/domain from each of the variable names.}
  \item{error}{a logical value controlling whether we raise an error
    if \code{x} is not a call to \code{a!localVariables},
    or instead return \code{character()}.
    This makes it convenient to \code{lapply} \code{localVarNames} to a
    a collection of code objects without having to deal with errors.
  }
}
\value{
A character vector.
}
\author{
Duncan Temple Lang
}
\seealso{
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
