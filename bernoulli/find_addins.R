# This script searches CRAN for packages that are likely RStudio addins.
# It looks for the keyword "addin" in the package Title or Description.

# 1. Get the full database of CRAN packages
cat("Fetching CRAN package database...\n")
pdb <- tools::CRAN_package_db()

# 2. Search for keyword (case-insensitive) in Title or Description
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  keyword <- args[1]
} else {
  keyword <- "chatgpt"
}

cat(sprintf("Searching for keyword: '%s'...\n", keyword))

matches <- grepl(keyword, pdb$Title, ignore.case = TRUE) |
  grepl(keyword, pdb$Description, ignore.case = TRUE)

# 3. Extract the matching packages
addin_packages <- pdb[matches, c("Package", "Title", "Description", "Version")]

# 4. Sort by Package name
addin_packages <- addin_packages[order(addin_packages$Package), ]

# 5. Display the results
cat(sprintf(
  "\nFound %d packages that mention '%s':\n\n",
  nrow(addin_packages), keyword
))

# Print the first 20 results as an example
head(addin_packages[, c("Package", "Title")], 20)

# Optional: Save to a CSV file
write.csv(addin_packages, sprintf("rstudio_addins_list_%s.csv", keyword),
  row.names = FALSE
) # nolint: line_length_linter.
