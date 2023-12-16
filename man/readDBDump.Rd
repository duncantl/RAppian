\name{readDBDump}
\alias{readDBDump}
\title{Read the databases exported from Appian}
\description{
  This parses the JSON content exported from
  Appian that provides the contents of \dQuote{all}
  the tables in the Appian instance.
  This can be used to read a previously saved file
  exported via the Web interface
  or the contents retrieved from an HTTPS request
  via \code{\link{dbDump}}
}
\usage{
readDBDump(file = mostRecent("127_0_0_1.*\\.json$", dir), dir = ".", removePrefix = TRUE, efrmOnly = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{file}{the filename containing the JSON or the JSON itself}
  \item{dir}{the directory in which to find the most recented file containing the databse export}
  \item{removePrefix}{a logical value controlling whether to remove the
   prefix before the first \code{_} character in the table names, e.g., EFRM, CMN, EXP, RWM}
 \item{efrmOnly}{either a logical value controlling whether the
   RWM tables are excluded or retained (\code{FALSE}) from the results
   or a character vector of prefixes identifying the table names to include, e.g.,
    \code{c("EFRM", "EXP")}.}
}

\value{
  A list of data.frames.
  The names are the names of the tables in the databases and each
  element is the corresponding table.
}
%\references{}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{dbDump}}
}
\examples{
\dontrun{
  dbs = readDBDump(dir = "DBDumps")
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{IO}
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
