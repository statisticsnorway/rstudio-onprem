library(rix)

rix(
  # r_ver = "4.4.2",
  date = "2024-10-01",
  r_pkgs = c("dplyr", "ggplot2", "arrow", "renv", "rix", "RJDemetra"),
  git_pkgs = list(package_name = "fellesr", 
                  repo_url = "https://github.com/statisticsnorway/ssb-fellesr", 
                  commit = "cc6eded"),
  ide = "other",
  project_path = ".",
  overwrite = TRUE
)