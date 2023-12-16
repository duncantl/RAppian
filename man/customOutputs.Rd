\name{customOutputs}
\alias{customOutputs}
\alias{customInputs}
\alias{summarizeProcModel}
\title{Process model custom input and output assignments}
\description{
  These functions provide a description of different parts
  of a process model.
}
\usage{
summarizeProcModel(name, map = mkSummary())
customOutputs(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
customInputs(doc, map = NULL, asDF = TRUE, toR = TRUE, rewrite = length(map) > 0)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{name}{the name of the process model or the path to the XML document containing the process
    model or the parsed XML document}
  \item{doc}{the path to the XML file for the process model or the parsed XML document}
  \item{map}{a data.frame typically computed via \code{mkSummary} that describes all the objects in
    the Appian application.}
  \item{asDF}{a logical value controlling whether the result is returned as data.frame or a list}
  \item{toR}{a logical value controlling whether the code for the inputs and outputs is converted to
    R language objects}
  \item{rewrite}{a logical controlling whether we also rewrite the R version of the SAIL code via
   to replace UUIDs and domains with human-readable names.}
}
\value{
  \code{summarizeProcModel} returns a list with elements
  \item{nodes}{a data.frame describing the nodes in the process model}
  \item{processVars}{a data.frame describing the process variables}
  \item{interfaceInfo}{}
  \item{customOutputs}{a data.frame describing the custom output assignments in all of the nodes in
    the process model}
  \item{outputVarFuns}{a data.frame} %  with a row for each node and the output variables   XXX
  \item{dynamicName}{the code for the dynamic name for the process model}
  \item{name}{the static name of the process model}
  \item{file}{the path to the XML file for the process model}  
  
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
