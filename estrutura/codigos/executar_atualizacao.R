# R | executar_atualizacao.R | executar na raiz do repositorio.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Habilita UTF-8.
source("estrutura/codigos/executar_guias_teoria.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
source("estrutura/banco-de-dados/coletar.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
source("estrutura/codigos/2026-10-25-appa-FundamentosShannon.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
source("estrutura/codigos/2026-10-25-appa-GuiasEstudo.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
source("estrutura/codigo/aula02.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
source("estrutura/codigos/aula07_lsa.R", local = new.env(parent = globalenv()), encoding = "UTF-8") # Reexecuta a etapa com os dados proprios.
