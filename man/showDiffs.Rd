\name{showDiffs}
\alias{showDiffs}
\alias{showDiffDF}
\alias{changedRecords}
\alias{cmp}
\alias{stack}
\alias{changed}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Tools for finding changes to database tables}
\description{
  These functions help to compare snapshots of (Appian) databases
  to determine which tables changed and within those
  which rows were added and which changed.

  Some of these functions are focused on tracking records associated with a specific
  requestId in EForms.

  The names for \code{stack} is likely to change.
}
\usage{
showDiffs(new, prev, id = 94)
showDiffDF(new, prev, table, id = 94)
changed(new, prev, op = identical)
stack(new, prev, table, id = 94, byRecord = FALSE)    
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{new}{the new version of the database, a list of data.frames}
  \item{prev}{the previous/old version of the database}
  \item{id}{the Request ID of interest}
  \item{op}{the function for comparing two tables/data.frames, either \code{\link{identical}} or
    \code{\link{all.equal}}}
  \item{table}{the name of the table within the database}
  \item{byRecord}{a logical value controlling whether to return
    the two data.frames in \code{stack} or to group the
    corresponding records and return the list of these data.frames.}
}

\value{
  \code{changed} returns the character vector of names of the tables that are different.

  \code{showDiffs} and \code{showDiffDF} produce output for putting in a Markdown document.

  \code{stack} returns a list with the two data.frames after subsetting the specified table
  using the request id. One can then compare the rows.  It can be useful to
  \code{\link{rbind}} them together  and then split the records/rows on the value
  of the first column which is the unique identifier. This collects the rows that
  correspond to each other and allows one to compare them.
  \code{byRecord} allows the latter.
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
 # get original DB snapshot
 d0 = dbDump()

 # interact with Appian to generate some records

 # get the new DB snapshot
 d1 = dbDump()

 changed(d1, d0)
 showDiffs(d1, d0)
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
