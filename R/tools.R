# Helpers for easier simulation setup/visualization

#' Run time estimate for an Odin model run.
#' 
#' Perform test runs of an Odin model with the specified run parameters and 
#' return measured run time for planning large-scale simulation repeats and/or model parameter scans.
#' 
#' @param odin_model An Odin model `R6 <odin_model>`
#' @param ... Passed to `$run(...)`
#'
#' @returns Estimated run time and resource measured by test run.
#' @export
#'
#' @examples
#' # TODO
run_eta <- function(odin_model, ...){
  bm <- bench::mark(
    odin_model$run(...), min_time = 2, min_iterations = 3)
  rlang::inform(sprintf("Median run time = %s", as.character(bm$median)))
}



#' Compute periodicity of time series
#' 
#' Supports the following methods: `fft` and `lomb`. `lomb` uses the `lomb` 
#' package for computation. Please note that `lomb` can be resource intensive 
#' and significantly slower than `fft`.
#' 
#' If `ts_time` is provided, it is passed to the Lomb-Scargle algorithm for 
#' unevenly sampled data computation. In this case, `lomb` method returns 
#' period in unit of `ts_time`. `ts_time` has no effect on the `fft` method as 
#' it requires even time spacing.
#' 
#' If `ts_time` is `NULL`, assume even time spacing and period unit will be 
#' in the (implicitly provided) time spacing of the time series vector.
#' 
#' Power, SNR, and p-value of the period detection are method-specific:
#' 
#' 1. `fft`: power = Spectrum power of the peak. \
#' SNR = (power of peak)/(median power). p-value is not available (NA).
#' 2. `lomb`: power = LS power of the peak. \
#' SNR is not available (NA). p-value = LS p-value.
#' 
#'
#' @param ts_vector Numeric vector of time series
#' @param ts_time Numeric vector of time points (if `NULL` use "step" unit)
#' @param method Period calculation method.
#' 
#' @returns Named vector of length 4 (period, power, snr, p.value).
#' @export
#'
#' @examples
#' # Generate a period = 50 sine wave data with some noise (even spacing)
#' n <- 5000
#' time <- seq(1, n, by = 1)
#' ts_data <- sin(2 * pi * time / 50) + rnorm(n, sd = 0.5)
#' compute_period(ts_data)
#' compute_period(ts_data, method = "lomb")
#' # Uneven sampling of the previous data and run lomb method again
#' s <- sample(1:n, n/3)
#' compute_period(ts_data[s], time[s], method = "lomb")
compute_period <- 
  function(ts_vector, ts_time = NULL, method = "fft"){
    switch(
      method,
      fft = {
        # Compute FFT and get peak
        fft_result <- stats::fft(ts_vector)
        n <- length(ts_vector)
        freq <- (1:(n-1)) / n
        fft_result <- fft_result[2:n]
        power <- Mod(fft_result[1:(n/2)])
        peak_idx <- which.max(power)
        peak_power <- power[peak_idx]
        period <- 1 / freq[peak_idx]
        # Compute SNR
        noise_floor <- stats::median(power)
        snr <- peak_power / noise_floor
        c(period = period, power = peak_power, snr = snr, p.value = NA)
      },
      lomb = {
        if (is.null(ts_time)) ts_time <- seq_along(ts_vector)
        lsp_result <- lomb::lsp(ts_vector, ts_time, plot = FALSE)
        period <- 1 / lsp_result$peak.at[1]
        peak_power <- lsp_result$peak
        snr <- NA
        p.value <- lsp_result$p.value
        c(period = period, power = peak_power, snr = NA, p.value = p.value)
      },
      rlang::abort("Unsupported method.")
    )
  }



# Basic plot theme (ggplot2)
.plot_theme <- 
  ggplot2::theme_classic(base_size = 24) + 
  ggplot2::theme(legend.position = "none") + 
  ggplot2::theme(axis.line = ggplot2::element_line(size = 0.5)) + 
  ggplot2::theme(axis.ticks = 
                   ggplot2::element_line(size = 0.5, colour = "black")) + 
  ggplot2::theme(axis.text = ggplot2::element_text(colour = "black")) + 
  ggplot2::theme(axis.ticks.length = ggplot2::unit(10, "points"))


#' 2-D phase potrait plot
#' 
#' Provides convenience function to plot simulation trajectory of result from 
#' one run in 2-D phase space.
#'
#' @param df_result Data frame containing results to plot
#' @param x Column to plot as X-axis
#' @param y Column to plot as Y-axis
#' @param time Column to color the trajectory
#'
#' @returns ggplot object of phase portrait
#' @export
#'
#' @examples
#' # TODO
plot_phase <- function(df_result, x, y, time = NULL){
  
  # get columns to plot
  x <- deparse1(substitute(x))
  y <- deparse1(substitute(y))
  time <- deparse1(substitute(time))
  if (time == "NULL"){
    time <- "step"
  }
  
  if (!all(c(x,y,time) %in% names(df_result)))
    rlang::abort("x/y/time column(s) not present in df. Check names.")
  
  df_plot <- data.frame(
    x = df_result[[x]], y = df_result[[y]],
    time = df_result[[time]]
  )
  
  df_plot |>
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, color = time)) +
    ggplot2::geom_path(linewidth = 0.8, alpha = 1) +  # Connects points in order
    ggplot2::scale_color_gradient(low = "blue", high = "red") +  # Color gradient
    ggplot2::labs(x = x, y = y, color = time) +
    .plot_theme
}



#' Time series plot (multifaceted)
#' 
#' Provides convenience function to plot simulation trajectory of result from 
#' one run as time series. Supports plotting multiple states in faceted plot.
#' 
#' Support the following features:
#' 
#' 1. flexible start-end time of the series by `start_time` and `end_time`.
#' 2. row subset of data by a fixed `sample_time` (useful when time step is small for numerical precision).
#' 3. flexible time tick label spacing by `tick_time`.
#' 4. states to plot are selected by `tidy-select`.
#' 
#' Please note that this function does not attempt to do exhaustive sanity 
#' check of parameters Make sure yourself that parameters make sense (e.g., 
#' end-start time must be longer than sample_time and tick_time, etc.)
#'
#' @param df_result Data frame containing results to plot. Must have column $time.
#' @param start_time Plot start time.
#' @param end_time Plot end time.
#' @param sample_time Time interval to subset data.
#' @param tick_time X-axis label break interval time (default 2*sample_time).
#' @param ... ... <[`tidy-select`][tidyselect::language]> Columns to plot.
#'
#' @returns ggplot object of faceted time series
#' @export
#'
#' @examples
#' # TODO
plot_timeSeries <- 
  function(df_result, start_time, end_time, 
           sample_time, tick_time, ...){
  
  # Process time and subset data
  if (is.null(df_result[["time"]]))
    rlang::abort("Data must have $time column.")
  #   Time start-end cutoff
  df_sel <- df_result[["time"]]
  df_sel <- df_sel >= start_time & df_sel <= end_time
  df_result <- df_result[df_sel,]
  #   Resampling of rows by sample_time
  df_sel <- rle(df_result[["time"]] %/% sample_time)
  df_sel <- df_sel$lengths |> cumsum()
  df_sel <- c(1, df_sel[2:length(df_sel)])
  df_result <- df_result[df_sel,]
  #   Column selection
  tryCatch(
    df_result <- df_result |> dplyr::select(rlang::sym("time"), ...),
    error = function(e) 
      rlang::abort("Not all columns present in data.", parent = e)
  )
  
  # Reshape data for plotting
  df_result <- df_result |>
    tidyr::pivot_longer(
      -rlang::sym("time"), names_to = "state", values_to = "value")
  
  # Tick positions
  time.ticks <- 
    seq(from = start_time, to = end_time, by = tick_time)
  
  # Plot
  time <- value <- "Binding check bypass only"
  ggplot2::ggplot(df_result, ggplot2::aes(x=time, y=value))+
    ggplot2::geom_point(shape = 16, size = 1)+
    ggplot2::geom_line(linewidth = 0.6)+
    ggplot2::scale_x_continuous(breaks = time.ticks)+
    ggplot2::scale_y_continuous(expand = c(.1, .1))+
    ggplot2::facet_wrap(
      facets = rlang::sym("state"), ncol = 1, scales = "free_y",
      strip.position = "right")+
    .plot_theme
}
