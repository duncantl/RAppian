\name{dbDump}
\alias{dbDump}
\title{Download and read the Appian databases}
\description{
  Using a valid cookie, fetch and optionally read
  the databases in an Appian instance.
}
\usage{
dbDump(con = mkDBCon(cookie, ...),
       cookie = getDBCookie(),
       params = DBParams,
       url = "https://ucdavisdev.appiancloud.com/database/index.php?route=/export",
       read = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{con}{the \code{RCurl} connection created via \code{mkDBCon}}
  \item{cookie}{the cookie for the HTTP request
    which can be provided as a character
    string or stored in a file \code{~/appiandev.cookie},
    \code{~/appian.cookie} or \code{appian.cookie} in the
    current working directory.}  
  \item{params}{the long list of parameters passed in the HTTP request.
    This lists all the tables. As new ones are added, they will have to be
    added to \code{DBParams} or in each call. 
  }
  \item{url}{the URL for the HTTPS request. Since we
    work with development, test and production instances,
    we need to be able to switch between them}
  \item{read}{a logical value controlling whether
    we return the JSON content or parse it into a list of data.frames
    via \code{readDBDump}}
  \item{\dots}{additional arguments passed to \code{mkDBCon}
    which passes them to \code{RCurl::getCurlHandle}}
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
}
\author{
Duncan Temple Lang
}
\note{
  There is code in dbDump.R to update/recompute the
  value of the DBParams object.
}


\seealso{
  \code{\link{readDBDump}}
}
\examples{
  \dontrun{
    db = dbDump(cookie = "....")
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
\keyword{IO}
