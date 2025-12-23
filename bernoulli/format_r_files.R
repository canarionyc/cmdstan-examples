# This script formats R files using the 'styler' package.
# Usage: Rscript format_r_files.R <path_to_file_or_directory>

# 1. Check/Install styler
if (!requireNamespace("styler", quietly = TRUE)) {
  cat("Installing 'styler' package for formatting...\n")
  install.packages("styler", repos = "https://cloud.r-project.org")
}

library(styler)

# 2. Get arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  # Default to current directory if no argument provided
  target <- "."
} else {
  target <- args[1]
}

# 3. Format
if (dir.exists(target)) {
  cat(sprintf("Formatting all R files in directory: %s\n", target))
  style_dir(target)
} else if (file.exists(target)) {
  cat(sprintf("Formatting file: %s\n", target))
  style_file(target)
} else {
  stop(sprintf("Target not found: %s", target))
}
