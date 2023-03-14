
library(deSolve) # using the "ode" function

# Step 1: writing the differential equations
sir_equations <- function(time, variables, parameters) {
  with(as.list(c(variables, parameters)), {
    dS <- mu-mu*S-beta*A*S-beta*I*S
    dE <- beta*A*S+beta*I*S-sigma*E-mu*E
    dA <- (1-rho)*sigma*E-gamma1*A-mu*A
    dI <- rho*sigma*E-gamma2*I-mu*I
    dR <-  gamma1*A+gamma2*I-mu*R
    return(list(c(dS, dE, dA, dI, dR)))
  })
}

# Defining values for the parameters

parameters_values <- c(
  alpha  = 1/60, 
  beta  = 0.0015, # infectious contact rate 
  sigma = 1/5,
  gamma1 = 1/9.5,    # recovery rate 
  gamma2 = 1/13.4,
  mu = 1/(60*365),    # death rate = birth rate
  rho = 0.87
)



# Defining initial values for the variables
initial_values <- c(
  S = 729,  # number of susceptibles at time = 0
  E = 1,
  A = 2,
  I = 7,  # number of infectious at time = 0
  R = 8   # number of recovered (and immune) at time = 0
)

# The points in time where to calculate variables values

time_values <- seq(0, 60, by = 1) # days

# Numerically solving the SIR model

sir_values_1 <- ode(
  y = initial_values,
  times = time_values,
  func = sir_equations,
  parms = parameters_values 
)

sir_values_1 <- as.data.frame(sir_values_1)


with(sir_values_1, {
  # plotting the time series of susceptible:
  plot(time, 0.0375*I/747, type = "l", col = "red",ylim = c(0,0.03), lwd=3.0, 
       xlab = "Tempo (dias)", ylab = "Proporção dos infectados diagnosticados")
  # adding the time series of exposed:
  lines(time, 0.0375*E/747, col = "yellow")
  # adding the time series of asyntomatic infected:
  lines(time, 0.0375*A/747, col = "orange")
  # adding the time series of syntomatic infected:
  lines(time, 0.0375*S/747, col = "blue")
  # adding the time series of recovered:
  lines(time, 0.0375*R/747, col = "green")
})

grid(nx = NULL, ny = NULL,
     lty = 3,      # Grid line type
     col = "gray", # Grid line color
     lwd = 1)      # Grid line width

# adding a legend:
legend("right", c("Susceptible", "Infected", "Recovered"),
       col = c("blue", "red", "green"))








