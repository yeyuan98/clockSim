# Run simulation

#' Get all clock model Odin generator objects
#' 
#' Refer to package documentation on preconfigured models in this package. 
#' This function is intended for advanced usage only; normally calling 
#' other helper functions will suffice for simulation.
#'
#' @returns Named list of Odin generator R6 objects.
#' @export
#'
#' @examples
#' # TODO
getOdinGen <- function(){
  return(list(
    discrete_LG_noisy = discrete_leloup_goldbeter_noisy,
    discrete_LG = discrete_leloup_goldbeter
  ))
}

