# R | motor-appa.R | R 4.3+ | executar na raiz de pi3.
if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8")) # Habilita leitura UTF-8.
source("estrutura/codigos/motor-professor/motor08.R", encoding = "UTF-8") # Carrega o contrato da disciplina localmente.
preparar_professor <- preparar # Preserva o preparo original sem alterar o arquivo do professor.
preparar <- function(texto, cfg = cfg_aula()) { # Estende o preparo com a decisao APPA sobre radicais.
  termos <- preparar_professor(texto, cfg) # Aplica a mesma limpeza e stopwords no corpus e na consulta.
  if (isTRUE(cfg$stemming)) { # Usa Snowball somente se configurado.
    if (!requireNamespace("SnowballC", quietly = TRUE)) stop("Instale SnowballC.") # Exige a dependencia explicitamente.
    termos <- SnowballC::wordStem(termos, language = "portuguese") # Reduz flexoes a radicais.
  } # Conclui o tratamento opcional.
  termos # Retorna o vetor de termos preparado.
} # Fecha a extensao do motor.
rocchio <- function(q, Dr, Dnr = character(0), ix, a = 1, b = .75, g = .15) { # Implementa a truncagem pedida no guia.
  cr <- if (length(Dr)) rowMeans(ix$w[, Dr, drop = FALSE]) else rep(0, length(q)) # Trata ausencia de relevantes vistos.
  cnr <- if (length(Dnr)) rowMeans(ix$w[, Dnr, drop = FALSE]) else rep(0, length(q)) # Trata ausencia de nao relevantes vistos.
  pmax(0, a * q + b * cr - g * cnr) # Mantem pesos nao negativos no espaco de termos.
} # Fecha a adaptacao de Rocchio.
