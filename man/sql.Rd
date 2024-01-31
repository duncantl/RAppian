\name{sql}
\alias{sql}
\title{Execute SQL command in Appian Database}
\description{
 This sends a SQL command to the Appian database.
}
\usage{
sql(query, cookie, token = NA, url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/import", ...)
}
\arguments{
  \item{query}{the SQL query as a string}
 \item{cookie}{the cookie from the Web browser connected to the Appian database}
 \item{token}{the token extracted from a sample SQL query run in the browser and copied from the
   request of that HTTP request.}
  \item{url}{the URL to the Appian database. This allows us to specify dev, test or prod database.}
  \item{\dots}{additional arguments for the HTTP request, i.e., RCurl}
}
\value{
 A data.frame or an error.
}
%\references{}
\author{
Duncan Temple Lang
}
\seealso{
 \link{dbDump}
}
%\examples{}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{IO}
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
