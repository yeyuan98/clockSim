% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/periodicity.R
\name{compute_period}
\alias{compute_period}
\title{Compute periodicity of time series}
\usage{
compute_period(ts_vector, ts_time = NULL, method = "fft", verbose = FALSE, ...)
}
\arguments{
\item{ts_vector}{Numeric vector of time series}

\item{ts_time}{Numeric vector of time points (if \code{NULL} use "step" unit)}

\item{method}{Period calculation method.}

\item{verbose}{Whether to print verbose messages on, e.g., time resolution.}

\item{...}{Passed to the specific method for finer control, see details.}
}
\value{
Named vector of length 4 (period, power, snr, p.value).
}
\description{
Supports the following methods: \code{fft} and \code{lomb}. \code{lomb} uses the \code{lomb}
package for computation. Please note that \code{lomb} can be resource intensive
and significantly slower than \code{fft}.
}
\details{
If \code{ts_time} is provided, it is passed to the Lomb-Scargle algorithm for
unevenly sampled data computation. In this case, \code{lomb} method returns
period in unit of \code{ts_time}. \code{ts_time} has no effect on the \code{fft} method as
it requires even time spacing.

If \code{ts_time} is \code{NULL}, assume even time spacing and period unit will be
in the (implicitly provided) time spacing of the time series vector.

Power, SNR, p-value, and ellipsis of the period detection are method-specific:
\enumerate{
\item \code{fft}: power = Spectrum power of the peak.
SNR = (power of peak)/(median power). p-value is not available (NA).
In this case, \code{...} is not used
\item \code{lomb}: power = LS power of the peak.
SNR is not available (NA). p-value = LS p-value.
In this case, \code{...} is forwarded to \code{lomb::lsp()}. Note: It is assumed that
the period of interest is >1. Otherwise result will be incorrect.
}
}
\examples{
# Generate a period = 50 sine wave data with some noise (even spacing)
n <- 1000
time <- seq(1, n, by = 1)
ts_data <- sin(2 * pi * time / 50) + rnorm(n, sd = 0.5)
compute_period(ts_data)
compute_period(ts_data, method = "lomb")
# Uneven sampling of the previous data and run lomb method again
s <- sample(1:n, n/3)
compute_period(ts_data[s], time[s], method = "lomb")
}
