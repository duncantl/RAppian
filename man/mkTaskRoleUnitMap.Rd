\name{mkTaskRoleUnitMap}
\alias{mkTaskRoleUnitMap}
\title{EForms specific function}
\description{
  This is highly specific to the Appian application we are developing.
  See Rscripts/TasksTypesForRoles.R
  
  It connects the task master information with the roles for those tasks.
  This works on the constant objects which are copies of the values in the
  database tables(!)
}
\usage{
mkTaskRoleUnitMap(x, map)
}
\arguments{
  \item{x}{}
  \item{map}{the data.frame describing all of the objects in the
    Appian application, typically obtained via call to \code{\link{mkSummary}}.
    If this is supplied, the result includes a column
    for the type of the variables providing the human-readable type name rather than the UUID.
  }
}
\value{
}
\author{
  Duncan Temple Lang
}
\seealso{
}
\examples{
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
