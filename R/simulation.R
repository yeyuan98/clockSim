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
    discrete_LG = discrete_leloup_goldbeter,
    continuous_LG = deriv_leloup_goldbeter
  ))
}

getModel_LG_Discrete <- function(){
  # User needs to provide common parameters here
}

testModelStepSize <- function(){
  # User provide the model, the step size parameter name, and step sizes to test
  # Plot a diagnostic convergence plot and propose a suitable step size
}