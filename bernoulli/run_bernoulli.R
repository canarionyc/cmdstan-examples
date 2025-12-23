exe_path <- "bernoulli.exe"
data_path <- "bernoulli.data.json"

if (!file.exists(exe_path)) {
  stop("Executable not found. Make sure you are in the correct directory.")
}

run_command <- function(method) {
  # Construct the command string
  # On Windows, we might need to ensure the path uses backslashes or is quoted if it has spaces, 
  # but for simple relative paths, this usually works.
  args <- c(method, "data", paste0("file=", data_path))
  
  cat(sprintf("Running: %s %s\n", exe_path, paste(args, collapse=" ")))
  system2(exe_path, args)
}

while (TRUE) {
  cat("\n=== CmdStan Bernoulli Runner (R) ===\n")
  cat("1. Sample (MCMC)\n")
  cat("2. Optimize (MLE)\n")
  cat("3. Variational (ADVI)\n")
  cat("4. Diagnose\n")
  cat("Q. Quit\n")
  
  selection <- readline(prompt="Select an option: ")
  
  if (selection == "1") {
    run_command("sample")
  } else if (selection == "2") {
    run_command("optimize")
  } else if (selection == "3") {
    run_command("variational")
  } else if (selection == "4") {
    run_command("diagnose")
  } else if (tolower(selection) == "q") {
    break
  } else {
    cat("Invalid selection\n")
  }
}
