% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createVarCov.R
\name{varCov}
\alias{varCov}
\alias{createVarCov}
\title{S3 class varCov}
\usage{
createVarCov(STA, choice, summary, vcov, criterion, engine, dat, trait)
}
\arguments{
\item{STA}{An object of class STA, the best fitted model.}

\item{choice}{A character string indicating the best fitted model.}

\item{summary}{A data.frame with a summary of the fitted models.}

\item{vcov}{The covariance matrix of the best fitted model.}

\item{criterion}{A character string indicating the goodness-of-fit criterion
used for determinening the best model.}

\item{engine}{A character string containing the engine used for the analysis.}
}
\description{
Function for creating objects of S3 class varCov.\cr
\code{\link{print}}, \code{\link{summary}}, \code{\link{plot}} and
\code{\link{report}} methods are available.
}
\keyword{internal}
