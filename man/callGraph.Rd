\name{callGraph}
\alias{callGraph}
\alias{findAppianCalledFuns}
\alias{findAppianConstants}
\alias{findAppianRecordTypeUses}
\title{Process which SAIL code calls other SAIL objects}
\description{
  This is a relatively general function that processes
  the code of a collection of SAIL objects and finds
  which code contains calls.
  This can record the simple \sQuote{x calls y} relationship,
  but can also extract other relationships
  such as \sQuote{x uses constant y} or
  \sQuote{x uses record type y}.
}
\usage{
callGraph(funNames, codeObjs, asDf = FALSE, funOp = findAppianCalledFuns, ...)
}
\arguments{
  \item{funNames}{a character vector identifying elements in
  \code{codeObjs} whose SAIL code to proces for calls}
  \item{codeObjs}{a list of SAIL code converted to R language objects,
   either in raw form (using URNs) or rewritten to use symbolic names.}
  \item{asDf}{a logical scalar value controlling whether we return
  the results as a 2-columm data.frame or a list of \sQuote{x uses y}}
  \item{funOp}{the function to extract the \sQuote{used objects} from each SAIL code object}
  \item{\dots}{additional arguments passed to each call to \code{funOp}}
}
\value{
  Either a 2 column data.frame with the first column being the name
  of the code that uses the object named in the second column,
  or
  a list with an element for each SAIL code object
  that is called directly on indirectly and a character vector
  of the SAIL objects it uses.
}
\author{
Duncan Temple Lang
}
\seealso{
  % \code{\link{uses}},   \code{\link{uses0}}
   \code{\link{usedBy}}
}
\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
