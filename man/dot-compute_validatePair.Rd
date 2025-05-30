% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/similarity.R
\name{.compute_validatePair}
\alias{.compute_validatePair}
\title{Trajectory similarity: validate consistency of result matrix pair}
\usage{
.compute_validatePair(res_mat1, res_mat2)
}
\arguments{
\item{res_mat1}{Trajectory matrix 1, first column must be time while others are states.}

\item{res_mat2}{Trajectory matrix 2, first column must be time while others are states.}
}
\description{
Verify that the two matrices share the same time values and the same states.
}
\examples{
# Internal only; error if check fails.
}
