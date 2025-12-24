
# ---- Check if rstan is installed (for stan_trace, stan_dens, etc.) ----
if (!requireNamespace("rstan", quietly = TRUE)) {
  install.packages("rstan")
}

if (!requireNamespace("rstan", quietly = TRUE)) {
  stop(paste("Package 'rstan' is needed for this script.",
             "Please run: install.packages('rstan')"))
}
library(rstan) # For stan_trace, stan_dens, etc.
options(mc.cores = parallel::detectCores()) # For execution on a local, multicore CPU with excess RAM
rstan_options(auto_write = TRUE) # To avoid recompilation of unchanged Stan programs
rstan_options(threads_per_chain = 1) # For within-chain threading using `reduce_sum()` or `map_rect()` Stan functions
rstan_options()

# ---- Check if coda is installed ----
if (!requireNamespace("coda", quietly = TRUE)) {
  install.packages("coda")
}

if (!requireNamespace("coda", quietly = TRUE)) {
  stop(paste("Package 'coda' is needed for this script.",
             "Please run: install.packages('coda')"))
}
library(coda)



# Configuration ----
setwd("C:/cmdstan/examples/bernoulli")
getwd()
exe_path <- "./bernoulli.exe"
data_path <- "bernoulli.data.json"
output_file <- "output.csv"

# 1. Run the Sampler ----
if (!file.exists(exe_path)) {
  stop("Executable not found. Please build the model first.")
}

cat("Running MCMC sampling..\n")
# Note: To run multiple chains for convergence diagnostics (like Gelman-Rubin),
# you would typically run this multiple times with different output files.
# Here we run a single chain for demonstration.
args <- c("sample",
          "data", paste0("file=", data_path),
          "data", paste0("file=", data_path),
          "output", paste0("file=", output_file))

# Run the executable
print(exe_path)
result <- system2(exe_path, args, stdout = FALSE)
if (result != 0) stop("Sampling failed.")

# 2. Read the data
cat("Reading output file...\n")
# CmdStan CSVs use '#' for comments.
# This automatically handles the metadata and adaptation info lines.
raw_data <- read.csv(output_file, comment.char = "#")

# 3. Prepare for Coda
# Filter out sampler diagnostic columns (ending in __) except lp__ (log probability)
# We want to analyze the model parameters.
param_cols <- !grepl("__$", names(raw_data)) | names(raw_data) == "lp__"
mcmc_obj <- coda::mcmc(raw_data[, param_cols])

# 4. Analyze with Coda
cat("\n=== Coda Summary ===\n")
print(summary(mcmc_obj))

cat("\n=== Effective Sample Size ===\n")
print(effectiveSize(mcmc_obj))

cat("\n=== Autocorrelation (Lag 1, 5, 10, 50) ===\n")
print(autocorr.diag(mcmc_obj, lags = c(1, 5, 10, 50)))

# 5. Plotting
# This will open a plot window if run interactively
cat("\nGenerating plots...\n")
plot(mcmc_obj)
