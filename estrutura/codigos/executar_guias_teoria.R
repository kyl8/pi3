# R | executar_guias_teoria.R | executar na raiz de pi3.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Le UTF-8 nos guias originais.
options(repos = c(CRAN = "https://cloud.r-project.org")) # Define o espelho para a celula de dependencia da Aula 03.
dir.create("estrutura/codigos/guias", recursive = TRUE, showWarnings = FALSE) # Guarda os trechos literais extraidos.
dir.create("estrutura/resultados/guias/teoria", recursive = TRUE, showWarnings = FALSE) # Guarda as transcricoes computacionais.
arquivos <- list.files("tutoras", pattern = "^GUIA_ESTUDO_aula[0-9]+b?\\.md$", full.names = TRUE) # Seleciona as oito teorias.
log <- list() # Acumula o status de cada bloco.
for (arquivo in arquivos) { # Executa cada aula isoladamente.
  nome <- sub("GUIA_ESTUDO_", "", sub("\\.md$", "", basename(arquivo))) # Define nome local do roteiro.
  texto <- readLines(arquivo, encoding = "UTF-8", warn = FALSE) # Preserva os exemplos originais.
  inicio <- grep("^# PARTE B", texto)[1]; fim <- grep("^# PARTE C", texto)[1] # Limita a extracao ao conteudo teorico.
  if (is.na(inicio) || is.na(fim)) next # Evita instrucoes de upload ou sessao interativa.
  conteudo <- texto[seq.int(inicio, fim - 1)] # Seleciona o material de estudo.
  aberturas <- grep("^```r[[:space:]]*$", conteudo) # Localiza os blocos R.
  env <- new.env(parent = globalenv()) # Isola variaveis de cada aula.
  env$install.packages <- function(pkgs, ...) { faltam <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]; if (length(faltam)) utils::install.packages(faltam, ...) } # Reaproveita dependencias instaladas.
  motor <- if (nome == "aula00") "motor01" else paste0("motor", sub("aula", "", nome)) # Carrega apenas as funcoes anteriores.
  sys.source(file.path("estrutura/codigos/motor-professor", paste0(motor, ".R")), env, keep.source = TRUE) # Usa a versao local do professor.
  if (exists("docs_aula", env, inherits = FALSE)) { env$docs <- env$docs_aula(); env$cfg <- env$cfg_aula(); env$ix <- env$montar(env$docs, env$cfg) } # Recria a primeira celula dos guias.
  roteiro <- c(paste0("# R | ", nome, "_teoria.R | blocos literais do guia; executar pelo runner.")) # Prepara a copia rastreavel dos exemplos.
  transcricao <- character(0) # Guarda saida real, sem simular uma conversa.
  figura_aberta <- FALSE # Abre dispositivo somente quando houver um grafico.
  for (j in seq_along(aberturas)) { # Avalia um bloco por vez.
    a <- aberturas[j]; b <- a + which(grepl("^```", conteudo[(a + 1):length(conteudo)]))[1] # Encontra o fechamento do bloco.
    codigo <- paste(conteudo[(a + 1):(b - 1)], collapse = "\n") # Preserva exatamente o corpo R.
    if (!figura_aberta && grepl("(?<![A-Za-z_])(plot|ggplot|image|hist|barplot)\\s*\\(", codigo, perl = TRUE)) { png(file.path("estrutura/resultados/guias/teoria", paste0(nome, "-%02d.png")), width = 1100, height = 750, res = 120); figura_aberta <- TRUE } # Nao gera imagens vazias para aulas sem graficos.
    roteiro <- c(roteiro, paste0("\n# Bloco ", j), codigo) # Mantem o codigo disponivel para leitura.
    if (grepl("download.file|readline\\(|file.choose\\(|source\\(.*https|<(arquivo|usuario|nome)", codigo)) { # Detecta somente parametros ilustrativos, sem confundir comparacoes numericas.
      log[[length(log) + 1]] <- data.frame(aula = nome, bloco = j, status = "instrucao_ambiente", detalhe = "Nao e um exercicio numerico; dependencias instaladas previamente.") # Explica porque esse trecho nao precisa ser repetido.
      next # Segue para o proximo exemplo executavel.
    } # Termina o filtro de configuracao.
    erro <- NULL; avisos <- character(0) # Reinicia o registro do trecho.
    saida <- capture.output(tryCatch(withCallingHandlers(withVisible(eval(parse(text = codigo), env)), warning = function(w) { avisos <<- c(avisos, conditionMessage(w)); invokeRestart("muffleWarning") }), error = function(e) erro <<- conditionMessage(e))) # Executa e registra inclusive erros didaticos.
    log[[length(log) + 1]] <- data.frame(aula = nome, bloco = j, status = if (is.null(erro)) "executado" else "erro_a_conferir", detalhe = paste(c(erro, avisos), collapse = " | ")) # Nao disfarca falhas como sucesso.
    transcricao <- c(transcricao, paste0("BLOCO ", j), codigo, "SAIDA:", saida, if (!is.null(erro)) paste("ERRO:", erro), "") # Preserva evidencia de cada exemplo.
  } # Termina a execucao dos exemplos da aula.
  if (figura_aberta) dev.off() # Conclui apenas o dispositivo aberto pelo roteiro.
  writeLines(roteiro, file.path("estrutura/codigos/guias", paste0(nome, "_teoria.R"))) # Salva o roteiro extraido.
  writeLines(transcricao, file.path("estrutura/resultados/guias/teoria", paste0(nome, "-execucao.txt"))) # Salva as saidas verificadas.
} # Termina todas as teorias.
log <- do.call(rbind, log) # Reune o status dos exemplos.
write.csv(log, "estrutura/resultados/guias/teoria-status.csv", row.names = FALSE, fileEncoding = "UTF-8") # Permite auditar cobertura e falhas.
print(table(log$aula, log$status)); print(subset(log, status == "erro_a_conferir")) # Mostra o que precisa de verificacao.
