# Inicie com Rscript. A pasta de trabalho pode ser qualquer uma.
arquivo <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
if (length(arquivo) != 1L) stop("Execute com Rscript.")
pasta <- dirname(normalizePath(arquivo, winslash = "/", mustWork = TRUE))
setwd(file.path(pasta, "../../.."))
for (pkg in c("shiny", "SnowballC")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop('Instale os pacotes uma vez: install.packages(c("shiny", "SnowballC"))')
}
source(file.path(pasta, "busca.R"), local = TRUE, encoding = "UTF-8")
source(file.path(pasta, "app.R"), local = TRUE, encoding = "UTF-8")
porta <- Sys.getenv("APPA_PORT")
shiny::runApp(shiny::shinyApp(ui, server), host = "127.0.0.1",
  port = if (nzchar(porta)) as.integer(porta) else NULL,
  launch.browser = !nzchar(porta))
