# ==============================================================================
# MOTOR DE BUSCA - BAIXADA SANTISTA (ESPAÇO VETORIAL & BOOLEANO)
# Granularidade: Parágrafos como documentos (d1, d2, ..., dN)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SCRAPING ESTRUTURADO DE PARÁGRAFOS DA WIKIPÉDIA
# ------------------------------------------------------------------------------

extrair_paragrafos_wiki <- function(titulo) {
  titulo_url <- URLencode(titulo, reserved = TRUE)
  endereco <- paste0(
    "https://pt.wikipedia.org/w/index.php?title=",
    titulo_url,
    "&action=render"
  )

  linhas <- readLines(endereco, warn = FALSE, encoding = "UTF-8")
  conteudo_html <- paste(linhas, collapse = " ")

  # Remoção de ruídos (scripts, estilos, tabelas, caixas informativas, rodapés e referências)
  conteudo_html <- gsub("<script[^>]*>.*?</script>", " ", conteudo_html, perl = TRUE)
  conteudo_html <- gsub("<style[^>]*>.*?</style>", " ", conteudo_html, perl = TRUE)
  conteudo_html <- gsub("<table[^>]*>.*?</table>", " ", conteudo_html, perl = TRUE)
  conteudo_html <- gsub("<div[^>]*class=\"[^\"]*(navbox|reflist|mw-references|sidebar|infobox)[^\"]*\"[^>]*>.*?</div>", " ", conteudo_html, perl = TRUE)
  conteudo_html <- gsub("<sup[^>]*class=\"[^\"]*reference[^\"]*\"[^>]*>.*?</sup>", " ", conteudo_html, perl = TRUE)

  # Captura apenas os blocos de parágrafos <p>...</p>
  matches <- gregexpr("<p[^>]*>(.*?)</p>", conteudo_html, perl = TRUE)
  paragrafos_brutos <- regmatches(conteudo_html, matches)[[1]]

  # Limpeza de marcações HTML remanescentes e entidades
  paragrafos_limpos <- vapply(paragrafos_brutos, function(p) {
    p <- gsub("<[^>]+>", " ", p)
    p <- gsub("&nbsp;", " ", p, fixed = TRUE)
    p <- gsub("&amp;", "&", p, fixed = TRUE)
    p <- gsub("&quot;", "\"", p, fixed = TRUE)
    p <- gsub("&#39;", "'", p, fixed = TRUE)
    p <- gsub("&#[0-9]+;", " ", p)
    p <- gsub("\\s+", " ", p)
    trimws(p)
  }, FUN.VALUE = character(1), USE.NAMES = FALSE)

  # Filtro: descarta linhas vazias ou fragmentos menores que 50 caracteres (ex: notas soltas)
  paragrafos_limpos[nchar(paragrafos_limpos) >= 50]
}

cat("\nExtraindo paragrafos da Wikipedia...\n")

paragrafos_santos     <- extrair_paragrafos_wiki("Santos Futebol Clube")
paragrafos_portuguesa <- extrair_paragrafos_wiki("Associação Atlética Portuguesa")
paragrafos_jabaquara  <- extrair_paragrafos_wiki("Jabaquara Atlético Clube")

# Montagem do Corpus estruturado no formato d1, d2, ..., dN
todos_paragrafos <- c(paragrafos_santos, paragrafos_portuguesa, paragrafos_jabaquara)
ids_documentos   <- paste0("d", seq_along(todos_paragrafos))

docs <- setNames(todos_paragrafos, ids_documentos)

# Rastreamento de metadados (Origem de cada documento)
doc_origem <- setNames(
  c(
    rep("Santos FC", length(paragrafos_santos)),
    rep("Portuguesa Santista", length(paragrafos_portuguesa)),
    rep("Jabaquara", length(paragrafos_jabaquara))
  ),
  ids_documentos
)

cat("Corpus indexado com sucesso:", length(docs), "documentos (paragrafos) criados.\n\n")

# ------------------------------------------------------------------------------
# 2. TOKENIZAÇÃO E STOPWORDS FIXAS
# ------------------------------------------------------------------------------

stopwords_pt <- c(
  "a", "à", "às", "ao", "aos", "as", "o", "os",
  "de", "da", "das", "do", "dos", "e", "é", "em",
  "no", "na", "nos", "nas", "um", "uma", "uns", "umas",
  "para", "por", "com", "que", "se", "foi", "foram", "era", "eram",
  "são", "ser", "sendo", "como", "mais", "menos", "ou",
  "seu", "sua", "seus", "suas", "ele", "ela", "eles", "elas",
  "também", "já", "até", "entre", "sobre", "após", "antes",
  "ainda", "quando", "onde", "pela", "pelo", "pelas", "pelos",
  "num", "numa", "nuns", "numas", "esse", "essa", "esses", "essas",
  "este", "esta", "estes", "estas", "isso", "isto", "lhe", "lhes",
  "me", "te", "muito", "muita", "muitos", "muitas", "mesmo", "mesma",
  "durante", "desde", "sem", "sob"
)

tokenizar <- function(texto) {
  texto <- tolower(texto)
  texto <- gsub("[[:punct:]]+", " ", texto)
  texto <- gsub("\\s+", " ", texto)
  tokens <- unlist(strsplit(trimws(texto), "\\s+"))
  tokens[tokens != ""]
}

# Tokenização de cada documento removendo stopwords
tokens_docs <- lapply(docs, function(txt) {
  toks <- tokenizar(txt)
  toks[!toks %in% stopwords_pt]
})

# ------------------------------------------------------------------------------
# 3. MATRIZ TERMO-DOCUMENTO (TDM) E PESOS TF-IDF
# ------------------------------------------------------------------------------

vocab <- sort(unique(unlist(tokens_docs)))

tdm <- sapply(tokens_docs, function(t) {
  as.integer(table(factor(t, levels = vocab)))
})
rownames(tdm) <- vocab

# Fórmulas do slide da aula
tf  <- tdm
N   <- ncol(tdm)
df  <- rowSums(tdm > 0)
idf <- log(N / df)
w   <- tf * idf

# ------------------------------------------------------------------------------
# 4. BUSCA VETORIAL (SIMILARIDADE DO COSSENO)
# ------------------------------------------------------------------------------

cosseno <- function(a, b) {
  norm_a <- sqrt(sum(a^2))
  norm_b <- sqrt(sum(b^2))
  if (norm_a == 0 || norm_b == 0) return(0)
  sum(a * b) / (norm_a * norm_b)
}

busca_vetorial <- function(consulta) {
  termos_query <- tokenizar(consulta)
  termos_query <- termos_query[!termos_query %in% stopwords_pt]

  if (length(termos_query) == 0) {
    cat("\nNenhum termo valido para consulta.\n")
    return(NULL)
  }

  # Vetorização da consulta
  q  <- as.integer(table(factor(termos_query, levels = vocab)))
  qw <- q * idf

  if (sum(qw^2) == 0) {
    cat("\nOs termos consultados nao constam no vocabulario do corpus.\n")
    return(NULL)
  }

  # Cálculo do cosseno contra todas as colunas de W
  scores <- apply(w, 2, function(dvec) cosseno(qw, dvec))
  
  # Filtro: apenas score > 0
  scores_validos <- scores[scores > 0]
  omitidos <- length(scores) - length(scores_validos)

  if (length(scores_validos) == 0) {
    cat("\nNenhum documento relevante encontrado.\n")
    return(NULL)
  }

  scores_ordenados <- sort(scores_validos, decreasing = TRUE)
  scores_top10 <- head(scores_ordenados, 10)

  docs_selecionados <- names(scores_top10)

  resultados <- data.frame(
    ID        = docs_selecionados,
    Clube     = doc_origem[docs_selecionados],
    Score     = round(as.numeric(scores_top10), 4),
    row.names = NULL
  )

  cat("\n=======================================================\n")
  cat("RESULTADOS DA BUSCA VETORIAL (TF-IDF + COSSENO)\n")
  cat("=======================================================\n")
  cat("Consulta:", consulta, "\n")
  cat("Termos avaliados:", paste(termos_query, collapse = ", "), "\n")
  cat("Documentos omitidos (Score = 0):", omitidos, "\n\n")
  print(resultados, row.names = FALSE)

  # Exibição dos parágrafos encontrados
  cat("\n=======================================================\n")
  cat("PARAGRAFOS RECUPERADOS (SNIPPETS)\n")
  cat("=======================================================\n")
  for (i in seq_along(docs_selecionados)) {
    id <- docs_selecionados[i]
    cat(sprintf("\n[%s] - %s (Score: %.4f):\n", id, doc_origem[id], scores_top10[i]))
    cat(docs[[id]], "\n")
  }
}

# ------------------------------------------------------------------------------
# 5. BUSCA BOOLEANA
# ------------------------------------------------------------------------------

busca_booleana <- function(expressao) {
  tokens_raw <- unlist(strsplit(trimws(expressao), "\\s+"))
  if (length(tokens_raw) == 0) {
    cat("\nConsulta booleana vazia.\n")
    return(NULL)
  }

  resultado_bool <- rep(TRUE, ncol(tdm))
  names(resultado_bool) <- colnames(tdm)

  op_atual <- "AND"
  termos_usados <- c()
  i <- 1

  while (i <= length(tokens_raw)) {
    tok <- toupper(tokens_raw[i])

    if (tok %in% c("AND", "E")) {
      op_atual <- "AND"
      i <- i + 1
    } else if (tok %in% c("OR", "OU")) {
      op_atual <- "OR"
      i <- i + 1
    } else if (tok %in% c("NOT", "NAO", "NÃO")) {
      op_atual <- "NOT"
      i <- i + 1
    } else {
      termo <- tolower(gsub("[[:punct:]]+", "", tokens_raw[i]))
      
      if (termo %in% stopwords_pt || termo == "") {
        i <- i + 1
        next
      }

      termos_usados <- c(termos_usados, termo)
      vetor_termo <- if (termo %in% vocab) (tdm[termo, ] > 0) else rep(FALSE, ncol(tdm))

      if (length(termos_usados) == 1) {
        if (op_atual == "NOT") {
          resultado_bool <- !vetor_termo
        } else {
          resultado_bool <- vetor_termo
        }
      } else {
        if (op_atual == "AND") {
          resultado_bool <- resultado_bool & vetor_termo
        } else if (op_atual == "OR") {
          resultado_bool <- resultado_bool | vetor_termo
        } else if (op_atual == "NOT") {
          resultado_bool <- resultado_bool & (!vetor_termo)
        }
      }
      op_atual <- "AND"
      i <- i + 1
    }
  }

  docs_validos <- names(resultado_bool[resultado_bool == TRUE])
  docs_top10 <- head(docs_validos, 10)

  if (length(docs_top10) == 0) {
    cat("\nNenhum documento atende aos criterios booleanos.\n")
    return(NULL)
  }

  resultados <- data.frame(
    ID        = docs_top10,
    Clube     = doc_origem[docs_top10],
    Status    = "TRUE",
    row.names = NULL
  )

  cat("\n=======================================================\n")
  cat("RESULTADOS DA BUSCA BOOLEANA\n")
  cat("=======================================================\n")
  cat("Expressao:", expressao, "\n")
  cat("Termos avaliados:", paste(unique(termos_usados), collapse = ", "), "\n")
  cat("Total de matches:", length(docs_validos), "\n\n")
  print(resultados, row.names = FALSE)

  # Exibição dos parágrafos recuperados
  cat("\n=======================================================\n")
  cat("PARAGRAFOS RECUPERADOS (SNIPPETS)\n")
  cat("=======================================================\n")
  for (id in docs_top10) {
    cat(sprintf("\n[%s] - %s:\n", id, doc_origem[id]))
    cat(docs[[id]], "\n")
  }
}

# ------------------------------------------------------------------------------
# 6. ESTATÍSTICAS E INTERFACE
# ------------------------------------------------------------------------------

mostrar_estatisticas <- function() {
  cat("\n=======================================================\n")
  cat("ESTATISTICAS DO CORPUS\n")
  cat("=======================================================\n")
  cat("Total de Documentos (Paragrafos N):", ncol(tdm), "\n")
  cat("  - Santos FC:", sum(doc_origem == "Santos FC"), "\n")
  cat("  - Portuguesa Santista:", sum(doc_origem == "Portuguesa Santista"), "\n")
  cat("  - Jabaquara:", sum(doc_origem == "Jabaquara"), "\n")
  cat("Total de Tokens:", sum(tdm), "\n")
  cat("Tamanho do Vocabulario:", nrow(tdm), "termos unicos\n\n")

  frequencia <- sort(rowSums(tdm), decreasing = TRUE)
  cat("10 termos mais frequentes no corpus:\n\n")
  print(head(frequencia, 10))
  cat("\n")
}

repeat {
  cat("\n=======================================================\n")
  cat("SISTEMA DE RECUPERACAO DE INFORMACAO - BAIXADA SANTISTA\n")
  cat("=======================================================\n")
  cat("1 - Busca Vetorial (TF-IDF + Cosseno)\n")
  cat("2 - Busca Booleana (AND, OR, NOT / E, OU, NAO)\n")
  cat("3 - Mostrar estatisticas do corpus\n")
  cat("0 - Sair\n\n")

  opcao <- readline("Escolha uma opcao: ")

  if (opcao == "1") {
    consulta <- readline("Digite os termos da busca: ")
    if (nchar(trimws(consulta)) > 0) {
      busca_vetorial(consulta)
    }
  } else if (opcao == "2") {
    consulta <- readline("Digite a consulta booleana (ex: estadio AND santos NOT jabaquara): ")
    if (nchar(trimws(consulta)) > 0) {
      busca_booleana(consulta)
    }
  } else if (opcao == "3") {
    mostrar_estatisticas()
  } else if (opcao == "0") {
    cat("\nPrograma encerrado.\n")
    break
  } else {
    cat("\nOpcao invalida. Tente novamente.\n")
  }
}