\name{getTestCases}
\alias{getTestCases}
\title{Get the test cases for an Expression Rule}
\description{
Get the code from the test cases from an expression rule.
}
\usage{
getTestCases(x, map)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{the file name or parsed XML document for the expression rule}
  \item{map}{the result of \link{mkSummary} for the entire application/package
    to associate the UUIDs in the code to other objects}
}
\value{
  A list of data.frames.
  Each data.frame has elements
  \item{name}{the name of the rule input/parameter}
  \item{value}{the literal value, if present, but could be in the code}
  \item{id}{the index}
  \item{type}{the type of the value/code, e.g, a:Expression, xsd:string, xsd:int}
  \item{code}{the value if an expression}  
}
\author{Duncan Temple Lang}

\seealso{
  \link{mkSummary}
}
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
\concept{meta analysis}
\concept{static code analysis}

