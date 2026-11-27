source("estrutura/codigos/motor-appa.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/aula07_funcoes.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/mmr.R", local = TRUE, encoding = "UTF-8")
source("estrutura/codigos/config.R", local = TRUE, encoding = "UTF-8")
pasta_corpus <- "estrutura/corpus/banco-de-dados"
documentos <- readRDS(file.path(pasta_corpus, "docs.rds"))
clubes <- readRDS(file.path(pasta_corpus, "origem.rds"))
stopifnot(length(documentos) > 0, !anyDuplicated(names(documentos)),
          setequal(names(documentos), names(clubes)))
indice <- montar(documentos, cfg)
modelo_lsa <- lsa(indice, cfg$lsa_k)
fontes <- c("Santos FC" = "Santos_Futebol_Clube",
            "Portuguesa Santista" = "Associa%C3%A7%C3%A3o_Atl%C3%A9tica_Portuguesa_(Santos)",
            "Jabaquara" = "Jabaquara_Atl%C3%A9tico_Clube")

buscar <- function(texto, modelo = cfg$modelo, reordenacao = "nenhuma", lambda = 0.7) {
  texto <- trimws(texto)
  if (!nzchar(texto)) return(list(mensagem = "Digite uma consulta para começar."))
  if (nchar(texto) > 200L) return(list(mensagem = "Use até 200 caracteres."))
  termos <- preparar(texto, cfg)
  if (!any(termos %in% indice$vocab))
    return(list(mensagem = "Nenhum termo da consulta aparece no vocabulário. Tente o nome de um clube ou estádio."))
  inicial <- if (modelo == "cosseno") ranking_cosseno(texto, indice, cfg) else
    ranking_modelo(texto, modelo, indice, cfg, modelo_lsa, c = cfg$rrf_c)
  ordem <- switch(reordenacao,
    nenhuma = names(inicial),
    mmr = rerank_mmr(inicial, indice$wn, 10L, lambda),
    proximidade = names(reordenar_appa(inicial, termos, indice, 10L, cfg$janela)),
    stop("Reordenação desconhecida."))
  list(inicial = names(inicial), final = ordem,
       redundancia = c(antes = redund(names(inicial), indice$wn),
                       depois = redund(ordem, indice$wn)))
}
