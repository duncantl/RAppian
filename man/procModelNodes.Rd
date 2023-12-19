\name{procModelNodes}
\alias{procModelNodes}
\alias{procModelVars}
\alias{procModelUses} % put somewhere else/
\alias{getPMWriteTypes}
\title{Get process model information}
\description{
  These return information about the nodes
  or the process variables in a process model.

  \code{getPMWriteTypes} computes which record types may be written
   within a process model.
}
\usage{
procModelNodes(doc, map = NULL)
procModelVars(doc, map = NULL)
getPMWriteTypes(pm, map) 
}
\arguments{
  \item{doc}{the filename of the XML file for the process model or
   the previously parsed XML document.}
  \item{map}{the data.frame describing all of the objects in the
    Appian application, typically obtained via call to \code{\link{mkSummary}}.
    If this is supplied, the result includes a column
    for the type of the variables providing the human-readable type name rather than the UUID.
  }
  \item{pm}{either the path to the XML document or the the data.frame
     from a call to \code{procModelNodes}}
}
\value{
 A data.frame.
}
%\references{}
\author{
Duncan Temple Lang
}

\seealso{
  \code{\link{mkSummary}}
}
\examples{

}

