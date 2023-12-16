\name{saveTo}
\alias{saveTo}
\title{Get the names of variables to which values are explicitly saved to in Appian code}
\description{
  This finds the target variable in calls to \code{a!save()}
  and for parameters \code{saveInto} and \code{selectSaveInto}.
}
\usage{
saveTo(x, asArg = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{the R version of the Appian code}
  \item{asArg}{a logical value that controls whether to look
    for variables specified in the code
    as the value of saveInto and selectSaveInto parameters
    in arbitrary calls, such as \code{a!radioButtonField}.
  }
}
\value{
  A character vector giving the fully-qualified names
  of the variables to which values are being explicitly saved/assigned.
}
\author{Duncan Temple Lang}
\seealso{
  \code{\link{StoR}}, \code{\link{rewriteCode}}
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
