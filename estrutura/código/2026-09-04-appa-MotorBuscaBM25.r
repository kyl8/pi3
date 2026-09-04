# ==============================================================================
# MOTOR DE BUSCA PROBABILISTICO - BM25 & COMPARATIVO COM TF-IDF
# Granularidade: Paragrafos como documentos (d1, d2, ..., dN)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SCRAPING ESTRUTURADO DE PARAGRAFOS DA WIKIPEDIA
# ------------------------------------------------------------------------------

extrair_paragrafos_wiki <- function(titulo) {
  # Codifica o titulo da pagina para inclusao segura na URL de requisicao
  titulo_url <- URLencode(titulo, reserved = TRUE)
  # Monta o endereco de renderizacao direta da Wikipedia em HTML
  endereco <- paste0(
    "https://pt.wikipedia.org/w/index.php?title=",
    titulo_url,
    "&action=render"
  )

  # Le todas as linhas do documento HTML recuperado
  linhas <- readLines(endereco, warn = FALSE, encoding = "UTF-8")
  # Junta todas as linhas em uma unica cadeia de caracteres
  conteudo_html <- paste(linhas, collapse = " ")

  # Remove tags de scripts para eliminar logica interativa da pagina
  conteudo_html <- gsub("<script[^>]*>.*?</script>", " ", conteudo_html, perl = TRUE)
  # Remove estilos visuais embutidos
  conteudo_html <- gsub("<style[^>]*>.*?</style>", " ", conteudo_html, perl = TRUE)
  # Remove tabelas completas para isolar apenas texto discursivo
  conteudo_html <- gsub("<table[^>]*>.*?</table>", " ", conteudo_html, perl = TRUE)
  # Remove caixas auxiliares de navegacao, referencias e infoboxes
  conteudo_html <- gsub("<div[^>]*class=\"[^\"]*(navbox|reflist|mw-references|sidebar|infobox)[^\"]*\"[^>]*>.*?</div>", " ", conteudo_html, perl = TRUE)
  # Remove indices de notas de rodape sobrescritas
  conteudo_html <- gsub("<sup[^>]*class=\"[^\"]*reference[^\"]*\"[^>]*>.*?</sup>", " ", conteudo_html, perl = TRUE)

  # Localiza todos os elementos de paragrafo delimitados por tags p
  matches <- gregexpr("<p[^>]*>(.*?)</p>", conteudo_html, perl = TRUE)
  # Extrai os conteudos dos paragrafos correspondentes
  paragrafos_brutos <- regmatches(conteudo_html, matches)[[1]]

  # Aplica limpeza profunda em cada paragrafo bruto extraido
  paragrafos_limpos <- vapply(paragrafos_brutos, function(p) {
    # Substitui qualquer tag HTML restante por espaco
    p <- gsub("<[^>]+>", " ", p)
    # Trata espacos inquebraveis
    p <- gsub("&nbsp;", " ", p, fixed = TRUE)
    # Decodifica o caractere reservado ampersand
    p <- gsub("&amp;", "&", p, fixed = TRUE)
    # Decodifica aspas duplas em entidades HTML
    p <- gsub("&quot;", "\"", p, fixed = TRUE)
    # Decodifica apóstrofos e aspas simples
    p <- gsub("&#39;", "'", p, fixed = TRUE)
    # Remove entidades numericas HTML genericas
    p <- gsub("&#[0-9]+;", " ", p)
    # Normaliza sequencias de espacos em branco repetidos
    p <- gsub("\\s+", " ", p)
    # Remove espacos adicionais nas extremidades do texto
    trimws(p)
  }, FUN.VALUE = character(1), USE.NAMES = FALSE)

  # Descarta fragmentos muito curtos mantendo apenas paragrafos consistentes
  paragrafos_limpos[nchar(paragrafos_limpos) >= 50]
}

cat("\nExtraindo paragrafos da Wikipedia...\n")

# Extracao dos dados dos tres clubes tradicionais da Baixada Santista
paragrafos_santos     <- extrair_paragrafos_wiki("Santos Futebol Clube")
paragrafos_portuguesa <- extrair_paragrafos_wiki("Associação Atlética Portuguesa")
paragrafos_jabaquara  <- extrair_paragrafos_wiki("Jabaquara Atlético Clube")

# Unificacao dos textos em um unico vetor ordenado de paragrafos
todos_paragrafos <- c(paragrafos_santos, paragrafos_portuguesa, paragrafos_jabaquara)
# Criacao dos identificadores unicos de documento no padrao d1 a dN
ids_documentos   <- paste0("d", seq_along(todos_paragrafos))

# Estruturacao do corpus como vetor nomeado pelos identificadores
docs <- setNames(todos_paragrafos, ids_documentos)

# Mapeamento do clube de origem de cada paragrafo
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
# 2. TOKENIZACAO E STOPWORDS FIXAS
# ------------------------------------------------------------------------------

# Lista de stopwords em portugues para desconsiderar palavras puramente gramaticais
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
  # Converte todos os caracteres para minusculo
  texto <- tolower(texto)
  # Substitui pontuacoes por espacos vazios
  texto <- gsub("[[:punct:]]+", " ", texto)
  # Normaliza espacos multiplos em espaco unico
  texto <- gsub("\\s+", " ", texto)
  # Divide a string em palavras individuais usando espacos como delimitador
  tokens <- unlist(strsplit(trimws(texto), "\\s+"))
  # Retorna apenas tokens validos e nao vazios
  tokens[tokens != ""]
}

# Tokeniza cada documento e filtra imediatamente as stopwords em portugues
tokens_docs <- lapply(docs, function(txt) {
  toks <- tokenizar(txt)
  toks[!toks %in% stopwords_pt]
})

# ------------------------------------------------------------------------------
# 3. MATRIZ TERMO-DOCUMENTO E METRICAS DO BM25 (SLIDES DA AULA 04)
# ------------------------------------------------------------------------------

# Monta o vocabulario ordenado com todos os termos unicos do corpus
vocab <- sort(unique(unlist(tokens_docs)))

# Constroi a matriz termo-documento com contagens de frequencia
tdm <- sapply(tokens_docs, function(t) {
  as.integer(table(factor(t, levels = vocab)))
})
# Atribui o vocabulario como nome das linhas da matriz
rownames(tdm) <- vocab

# Matriz tf com linhas correspondendo a termos e colunas a documentos
tf <- tdm
# Quantidade total de documentos no corpus (N)
N <- ncol(tf)
# Frequencia de documento: quantos documentos contem cada termo
df <- rowSums(tf > 0)

# |d|: Comprimento de cada documento medido pelo total de tokens ativos
dl <- colSums(tf)
# avgdl: Comprimento medio dos documentos de todo o corpus
avgdl <- mean(dl)

# IDF probabilistico com suavizacao (+0.5) e limitador de valor negativo (+1)
idf <- log((N - df + 0.5) / (df + 0.5) + 1)

# IDF classico utilizado para o modelo vetorial TF-IDF de comparacao
idf_classico <- log(N / df)
# Matriz de pesos w do TF-IDF para testes comparativos de ranqueamento
w_tfidf <- tf * idf_classico

# Parametros padrao do BM25 conforme recomendacao da literatura e da aula
k1 <- 1.2 # Controla a taxa de saturacao da frequencia de termo
b  <- 0.75 # Controla o peso da penalizacao pelo comprimento do documento

# ------------------------------------------------------------------------------
# 4. FUNCAO NUCLEAR DO BM25 (LINHA A LINHA CONFORME O SLIDE 34)
# ------------------------------------------------------------------------------

bm25_doc <- function(termos, d) {
  s <- 0                                     # Acumulador do somatorio do documento
  for (t in termos) {                        # Itera sobre os termos da consulta do usuario
    if (!(t %in% vocab)) next                # Termo que nao existe no corpus contribui zero
    f <- tf[t, d]                            # f: frequencia observada do termo neste documento
    K <- k1 * (1 - b + b * dl[d] / avgdl)    # K: penalidade ajustada pelo tamanho do documento
    s <- s + idf[t] * (f * (k1 + 1)) / (f + K) # Incrementa a pontuacao ponderada com frequencia saturada
  }
  unname(s)                                  # Retorna a pontuacao final numerica pura (sem nomes) para o documento d
}

# ------------------------------------------------------------------------------
# 5. EXECUCAO DE BUSCA BM25
# ------------------------------------------------------------------------------

busca_bm25 <- function(consulta) {
  # Tokeniza o texto recebido na consulta
  termos_query <- tokenizar(consulta)
  # Remove as stopwords da consulta
  termos_query <- termos_query[!termos_query %in% stopwords_pt]

  # Verifica se sobrou algum termo valido na consulta
  if (length(termos_query) == 0) {
    cat("\nNenhum termo valido para consulta.\n")
    return(NULL)
  }

  # Calcula o score BM25 para cada documento do corpus
  scores <- sapply(colnames(tf), function(d) bm25_doc(termos_query, d))
  names(scores) <- colnames(tf)

  # Filtra documentos que tiveram pontuacao estritamente positiva
  scores_validos <- scores[scores > 0]
  omitidos <- length(scores) - length(scores_validos)

  # Verifica se houve ao menos um documento relevante encontrado
  if (length(scores_validos) == 0) {
    cat("\nNenhum documento relevante encontrado.\n")
    return(NULL)
  }

  # Ordena os documentos em ordem decrescente de pontuacao
  scores_ordenados <- sort(scores_validos, decreasing = TRUE)
  # Seleciona os 10 melhores resultados
  scores_top10 <- head(scores_ordenados, 10)
  docs_selecionados <- names(scores_top10)

  # Estrutura a tabela de resultados com identificador, clube e escore
  resultados <- data.frame(
    ID        = docs_selecionados,
    Clube     = doc_origem[docs_selecionados],
    Score     = round(as.numeric(scores_top10), 4),
    row.names = NULL
  )

  cat("\n=======================================================\n")
  cat(sprintf("RESULTADOS DA BUSCA PROBABILISTICA (BM25 - k1: %.2f, b: %.2f)\n", k1, b))
  cat("=======================================================\n")
  cat("Consulta:", consulta, "\n")
  cat("Termos avaliados:", paste(termos_query, collapse = ", "), "\n")
  cat("Documentos omitidos (Score = 0):", omitidos, "\n\n")
  print(resultados, row.names = FALSE)

  cat("\n=======================================================\n")
  cat("PARAGRAFOS RECUPERADOS (SNIPPETS)\n")
  cat("=======================================================\n")
  for (i in seq_along(docs_selecionados)) {
    id <- docs_selecionados[i]
    cat(sprintf("\n[%s] - %s (BM25 Score: %.4f):\n", id, doc_origem[id], scores_top10[i]))
    cat(docs[[id]], "\n")
  }
}

# ------------------------------------------------------------------------------
# 6. COMPARACAO DIRETA: BM25 VS TF-IDF (COSSENO)
# ------------------------------------------------------------------------------

cosseno <- function(a, b) {
  norm_a <- sqrt(sum(a^2))
  norm_b <- sqrt(sum(b^2))
  if (norm_a == 0 || norm_b == 0) return(0)
  sum(a * b) / (norm_a * norm_b)
}

comparar_ranqueamento <- function(consulta) {
  termos_query <- tokenizar(consulta)
  termos_query <- termos_query[!termos_query %in% stopwords_pt]

  if (length(termos_query) == 0) {
    cat("\nNenhum termo valido para consulta.\n")
    return(NULL)
  }

  # 1. Calculo do ranking via BM25
  scores_bm25 <- sapply(colnames(tf), function(d) bm25_doc(termos_query, d))
  names(scores_bm25) <- colnames(tf)
  validos_bm25 <- scores_bm25[scores_bm25 > 0]

  # 2. Calculo do ranking via TF-IDF com Cosseno
  q <- as.integer(table(factor(termos_query, levels = vocab)))
  qw <- q * idf_classico
  scores_tfidf <- if (sum(qw^2) > 0) {
    apply(w_tfidf, 2, function(dvec) cosseno(qw, dvec))
  } else {
    rep(0, ncol(tf))
  }
  validos_tfidf <- scores_tfidf[scores_tfidf > 0]

  top_n <- 10
  ordem_bm25  <- head(sort(validos_bm25, decreasing = TRUE), top_n)
  ordem_tfidf <- head(sort(validos_tfidf, decreasing = TRUE), top_n)

  # Montagem de tabela comparativa de posicoes
  tamanho_max <- max(length(ordem_bm25), length(ordem_tfidf))
  if (tamanho_max == 0) {
    cat("\nNenhum resultado encontrado em nenhum dos dois modelos.\n")
    return(NULL)
  }

  posicoes <- seq_len(tamanho_max)
  docs_bm25 <- names(ordem_bm25)[posicoes]
  docs_tfidf <- names(ordem_tfidf)[posicoes]

  tabela_comparativa <- data.frame(
    Posicao     = posicoes,
    BM25_Doc    = ifelse(is.na(docs_bm25), "-", docs_bm25),
    BM25_Clube  = ifelse(is.na(docs_bm25), "-", doc_origem[docs_bm25]),
    BM25_Score  = ifelse(is.na(docs_bm25), "-", round(as.numeric(ordem_bm25[posicoes]), 4)),
    TFIDF_Doc   = ifelse(is.na(docs_tfidf), "-", docs_tfidf),
    TFIDF_Clube = ifelse(is.na(docs_tfidf), "-", doc_origem[docs_tfidf]),
    TFIDF_Score = ifelse(is.na(docs_tfidf), "-", round(as.numeric(ordem_tfidf[posicoes]), 4)),
    row.names   = NULL
  )

  cat("\n=======================================================================\n")
  cat("COMPARATIVO DE RANQUEAMENTO: BM25 VS TF-IDF (COSSENO)\n")
  cat("=======================================================================\n")
  cat("Consulta:", consulta, "\n")
  cat("Parametros BM25: k1 =", k1, "| b =", b, "\n\n")
  print(tabela_comparativa, row.names = FALSE)
  cat("\nObserve as mudancas de posicao geradas pela saturacao de termos e penalizacao de tamanho.\n")
}

# ------------------------------------------------------------------------------
# 7. BUSCA BOOLEANA (MANTIDA DO SISTEMA ORIGINAL)
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
}

# ------------------------------------------------------------------------------
# 8. AJUSTE DINAMICO DE PARAMETROS E ESTATISTICAS
# ------------------------------------------------------------------------------

ajustar_parametros <- function() {
  cat(sprintf("\nParametros atuais: k1 = %.2f, b = %.2f\n", k1, b))
  
  novo_k1_str <- readline("Digite o novo valor para k1 (Enter para manter): ")
  novo_k1 <- as.numeric(trimws(novo_k1_str))
  if (!is.na(novo_k1) && novo_k1 >= 0) {
    k1 <<- novo_k1
    cat(sprintf("Parametro k1 atualizado para: %.2f\n", k1))
  } else if (nchar(trimws(novo_k1_str)) > 0) {
    cat("Valor invalido para k1. Mantido o anterior.\n")
  }

  novo_b_str <- readline("Digite o novo valor para b [0 a 1] (Enter para manter): ")
  novo_b <- as.numeric(trimws(novo_b_str))
  if (!is.na(novo_b) && novo_b >= 0 && novo_b <= 1) {
    b <<- novo_b
    cat(sprintf("Parametro b atualizado para: %.2f\n", b))
  } else if (nchar(trimws(novo_b_str)) > 0) {
    cat("Valor invalido para b. Deve estar entre 0 e 1. Mantido o anterior.\n")
  }
}

mostrar_estatisticas <- function() {
  cat("\n=======================================================\n")
  cat("ESTATISTICAS DO CORPUS E DO BM25\n")
  cat("=======================================================\n")
  cat("Total de Documentos (Paragrafos N):", ncol(tdm), "\n")
  cat("  - Santos FC:", sum(doc_origem == "Santos FC"), "\n")
  cat("  - Portuguesa Santista:", sum(doc_origem == "Portuguesa Santista"), "\n")
  cat("  - Jabaquara:", sum(doc_origem == "Jabaquara"), "\n")
  cat("Total de Tokens Filtrados:", sum(tdm), "\n")
  cat("Tamanho do Vocabulario:", nrow(tdm), "termos unicos\n")
  cat("Comprimento Medio de Documento (avgdl):", round(avgdl, 2), "tokens\n")
  cat("Comprimento Minimo de Documento:", min(dl), "tokens\n")
  cat("Comprimento Maximo de Documento:", max(dl), "tokens\n")
  cat(sprintf("Parametros Ativos do BM25: k1 = %.2f | b = %.2f\n\n", k1, b))

  frequencia <- sort(rowSums(tdm), decreasing = TRUE)
  cat("10 termos mais frequentes no corpus:\n\n")
  print(head(frequencia, 10))
  cat("\n")
}

# ------------------------------------------------------------------------------
# 9. MENU INTERATIVO PRINCIPAL
# ------------------------------------------------------------------------------

repeat {
  cat("\n=======================================================\n")
  cat("SISTEMA DE RECUPERACAO DE INFORMACAO - MOTOR BM25\n")
  cat(sprintf("Baixada Santista | k1: %.2f | b: %.2f\n", k1, b))
  cat("=======================================================\n")
  cat("1 - Busca BM25\n")
  cat("2 - Comparar Ranqueamento (BM25 vs. TF-IDF Cosseno)\n")
  cat("3 - Busca Booleana (AND, OR, NOT / E, OU, NAO)\n")
  cat("4 - Ajustar Parametros do BM25 (k1 e b)\n")
  cat("5 - Mostrar Estatisticas do Corpus\n")
  cat("0 - Sair\n\n")

  opcao <- readline("Escolha uma opcao: ")

  if (opcao == "1") {
    consulta <- readline("Digite os termos da busca BM25: ")
    if (nchar(trimws(consulta)) > 0) {
      busca_bm25(consulta)
    }
  } else if (opcao == "2") {
    consulta <- readline("Digite os termos para comparacao BM25 vs TF-IDF: ")
    if (nchar(trimws(consulta)) > 0) {
      comparar_ranqueamento(consulta)
    }
  } else if (opcao == "3") {
    consulta <- readline("Digite a consulta booleana (ex: estadio AND santos NOT jabaquara): ")
    if (nchar(trimws(consulta)) > 0) {
      busca_booleana(consulta)
    }
  } else if (opcao == "4") {
    ajustar_parametros()
  } else if (opcao == "5") {
    mostrar_estatisticas()
  } else if (opcao == "0") {
    cat("\nPrograma encerrado.\n")
    break
  } else {
    cat("\nOpcao invalida. Tente novamente.\n")
  }
}
