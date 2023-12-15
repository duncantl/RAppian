\name{StoR}
\alias{StoR}
\alias{rewriteCode}
\alias{findComments}
\title{Convert SAIL code to R language objects}
\description{
}
\usage{
StoR(x, parse = FALSE, procModel = FALSE)
rewriteCode(code, map, warn = FALSE, parse = TRUE) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{parse}{
%%     ~~Describe \code{parse} here~~
}
  \item{procModel}{
%%     ~~Describe \code{procModel} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x, parse = FALSE, procModel = FALSE) 
{
    x = gsub(",[[:space:]]*$", "", x)
    x = gsub("(![a-zA-Z0-9]+)\\.\\[", "\\1[", x)
    x = fixAdjStrings(x)
    x = removeComments(x)
    x = mkList(x)
    x = gsub("^= *", "", x)
    x = gsub(": =ri!", ": ri!", x)
    x = gsub(":= #\"", ": #\"", x)
    if (procModel) 
        x = gsub("&:", ":", x)
    x = changeOperators(x)
    x = gsub("(![a-zA-Z0-9]+)\\.(?= )", "\\1 & \".\" ", x, perl = TRUE)
    x = gsub("(![a-zA-Z0-9]+)\\.(?=[^ ])", "\\1$", x, perl = TRUE)
    x = escapeUUIDs(x)
    x = gsub("([a-z]+|AC)!([a-zA-Z0-9]+)", "`\\1!\\2`", x)
    x = gsub(": ", " = ", x)
    x = gsub("if\\(", "IF\\(", x)
    x = gsub("repeat\\(", "Repeat(", x)
    x = gsub("\\)\\.", ")$", x)
    x = gsub("= _([,)])", "= `_`\\1", x)
    x = gsub("\\(_([,)])", "(`_`\\1", x)
    x = gsub(" = == ", " == ", x)
    x = gsub("\\\\", "\\\\\\\\", x)
    if (parse) {
        ans = tryCatch(parse(text = x, keep.source = FALSE), 
            error = function(e) {
                parse(text = collapseLines(x), keep.source = FALSE)
            })
        if (is.expression(ans) && length(ans) == 1) 
            ans[[1]]
        else ans
    }
    else x
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
