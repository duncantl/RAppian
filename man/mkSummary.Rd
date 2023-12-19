\name{mkSummary}
\alias{mkSummary}
\alias{mkAppInfo} % direct alias of mkSummary.
\alias{xmlFiles}
\alias{getFolder}
\alias{toplevelUUIDs}
\title{Compute information about all objects in Appian app.}
\description{
  \code{mkSummary} reads all of the specified XML files in the
  Appian export and provides a description of each
  object as a row in a data.frame including the object name, type, description,
  SAIL code, uuid.

  \code{xmlFiles} returns the character vector
  of paths to all the XML files in the Appian directory and subdirectories.
  One can optionally remove the path to the directory to be able to
  reference the files relative to the root directory.

  \code{getFolder} computes the name of the folder for each of the
  Appian objects/XML files in the application.

  \code{toplevelUUIDS} gets the UUIDs from the XML files in the Appian application.
}
\usage{
mkSummary(dir = ".", showOthers = FALSE, recTypes = recordTypeInfo,
          recRels = recordTypeRelationships, xf = xmlFiles(dir))
getFolders(dir = ".", files = xmlFiles(dir))
xmlFiles(dir = ".", rmDir = dir == ".")
toplevelUUIDs(dir = ".", xf = xmlFiles(dir), simple = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dir}{the path to the directory containing the Appian export}
  \item{showOthers}{a logical value that controls whether
    we print the information about files in the directory but not in the
    list of XML files. This includes \code{.docx},
     \code{.xsd}, \code{.json} and files in the \code{META-INF} subdirectory.
  }
  \item{recTypes,recRels}{a function or \code{NULL}. If this is a function, it is called
      for each record type object, passing the file name of the XML file  corresponding to that
      record type. The results are then added as a column in the data.frame.
      For the result for recTypes is stored in the column named \code{recordType},
      and the result for recRels in a column named \code{recordRelationships}.
    }
    \item{xf}{the XML files as a character vector of full file names}
    \item{rmDir}{a logical value controlling whether to remove the common
      prefix which is \code{dir} to have relative file names.}
    \item{simple}{a logical value. If \code{TRUE}, we compute the UUIDs from
    the file name; otherwise, we call \code{\link{getUUID}} for each file to get the UUID.}
}
%\details{}
\value{
  A data.frame with a row for each XML file and elements
  \item{name}{the name of the Appian object}
  \item{type}{its type as a string}
  \item{uuid}{its UUID}
  \item{file}{the XML file for that object}
  \item{description}{the text describing the object.}
  \item{qname}{the qualified name, i.e. with the domain prefix such as \code{interface!},
  \code{constant!}, ...}
  \item{recordType}{a list. By default, any element corresponding to a \sQuote{recordType} is a
  data.frame describing the fields and their types in the record}
  \item{recordRelationships}{a list. By default, any element corresponding to a \sQuote{recordType} is a
  data.frame describing the relationships between fields in this record type and fields in other record types}
  \item{LOC}{the number of lines of code}      

}
%\references{}
\author{Duncan Temple Lang}
\seealso{}
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
