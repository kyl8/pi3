pacotes <- c("httr2", "dplyr", "tidytext", "tibble")

for (pacote in pacotes) {
  if (!requireNamespace(pacote, quietly = TRUE)) {
    install.packages(pacote, repos = "https://cloud.r-project.org")
  }
}

library(httr2)
library(dplyr)
library(tidytext)
library(tibble)


baixar_wiki <- function(titulo) {
  resposta <- request("https://pt.wikipedia.org/w/api.php") |>
    req_url_query(
      action = "query",
      prop = "extracts",
      explaintext = 1,
      format = "json",
      redirects = 1,
      titles = titulo
    ) |>
    req_perform() |>
    resp_body_json()
  
  resposta$query$pages[[1]]$extract
}


cat("\nBaixando artigos da Wikipedia...\n")

docs <- c(
  "Santos FC" = baixar_wiki("Santos Futebol Clube"),
  "Portuguesa Santista" = baixar_wiki("Associação Atlética Portuguesa"),
  "Jabaquara" = baixar_wiki("Jabaquara Atlético Clube")
)

cat("Corpus carregado com sucesso.\n\n")


corpus <- tibble(
  documento = names(docs),
  texto = unname(docs)
)


tokens <- corpus |>
  unnest_tokens(word, texto)


stopwords_pt <- tibble(
  word = c(
    "a", "à", "às", "ao", "aos", "as",
    "o", "os",
    "de", "da", "das", "do", "dos",
    "e", "é", "em",
    "no", "na", "nos", "nas",
    "um", "uma", "uns", "umas",
    "para", "por", "com",
    "que", "se",
    "foi", "foram", "era", "eram",
    "são", "ser", "sendo",
    "como", "mais", "menos", "ou",
    "seu", "sua", "seus", "suas",
    "ele", "ela", "eles", "elas",
    "também", "já", "até",
    "entre", "sobre", "após", "antes",
    "ainda", "quando", "onde",
    "pela", "pelo", "pelas", "pelos",
    "num", "numa", "nuns", "numas",
    "esse", "essa", "esses", "essas",
    "este", "esta", "estes", "estas",
    "isso", "isto",
    "lhe", "lhes",
    "me", "te", "nos",
    "muito", "muita", "muitos", "muitas",
    "mesmo", "mesma",
    "durante", "desde",
    "sem", "sob"
  )
) |>
  distinct()


preparar_tokens <- function(filtro_stopwords) {
  if (filtro_stopwords) {
    tokens |>
      anti_join(stopwords_pt, by = "word")
  } else {
    tokens
  }
}


preparar_consulta <- function(consulta, filtro_stopwords) {
  termos <- tibble(texto = consulta) |>
    unnest_tokens(word, texto) |>
    distinct(word)
  
  if (filtro_stopwords) {
    termos <- termos |>
      anti_join(stopwords_pt, by = "word")
  }
  
  termos
}


pesquisar <- function(consulta, filtro_stopwords) {
  termos <- preparar_consulta(
    consulta,
    filtro_stopwords
  )
  
  if (nrow(termos) == 0) {
    cat("\nNenhum termo válido para pesquisar.\n")
    return(NULL)
  }
  
  tokens_ativos <- preparar_tokens(
    filtro_stopwords
  )
  
  resultados <- tokens_ativos |>
    filter(word %in% termos$word) |>
    count(
      documento,
      sort = TRUE,
      name = "ocorrencias"
    )
  
  cat("\n========================================\n")
  cat("RESULTADOS DA PESQUISA\n")
  cat("========================================\n")
  
  cat("Pesquisa:", consulta, "\n")
  cat(
    "Termos considerados:",
    paste(termos$word, collapse = ", "),
    "\n\n"
  )
  
  if (nrow(resultados) == 0) {
    cat("Nenhum resultado encontrado.\n")
    return(NULL)
  }
  
  resultados <- resultados |>
    mutate(posicao = row_number()) |>
    select(
      posicao,
      documento,
      ocorrencias
    )
  
  print(resultados)
  
  list(
    resultados = resultados,
    termos = termos$word
  )
}


mostrar_frases <- function(termos, documentos_encontrados) {
  cat("\n========================================\n")
  cat("FRASES ENCONTRADAS\n")
  cat("========================================\n")
  
  total <- 0
  
  for (documento in documentos_encontrados) {
    texto <- docs[[documento]]
    
    texto <- gsub(
      "[\r\n]+",
      " ",
      texto
    )
    
    frases <- unlist(
      strsplit(
        texto,
        "(?<=[.!?])\\s+",
        perl = TRUE
      )
    )
    
    frases <- trimws(frases)
    frases <- frases[nchar(frases) > 0]
    
    frases_encontradas <- c()
    
    for (frase in frases) {
      frase_tokens <- tibble(texto = frase) |>
        unnest_tokens(word, texto)
      
      if (any(frase_tokens$word %in% termos)) {
        frases_encontradas <- c(
          frases_encontradas,
          frase
        )
      }
    }
    
    if (length(frases_encontradas) > 0) {
      cat("\n----------------------------------------\n")
      cat(documento, "\n")
      cat("----------------------------------------\n")
      
      for (i in seq_along(frases_encontradas)) {
        cat(
          "\n",
          i,
          ". ",
          frases_encontradas[i],
          "\n",
          sep = ""
        )
        
        total <- total + 1
      }
    }
  }
  
  if (total == 0) {
    cat("\nNenhuma frase encontrada.\n")
  }
  
  cat("\n")
}


mostrar_estatisticas <- function(filtro_stopwords) {
  tokens_ativos <- preparar_tokens(
    filtro_stopwords
  )
  
  vocab <- tokens_ativos |>
    distinct(word)
  
  freq <- tokens_ativos |>
    count(
      word,
      sort = TRUE
    )
  
  quantidade_vocab <- nrow(vocab)
  
  cat("\n========================================\n")
  cat("ESTATISTICAS DO CORPUS\n")
  cat("========================================\n")
  
  cat(
    "Stopwords:",
    ifelse(
      filtro_stopwords,
      "ATIVADAS",
      "DESATIVADAS"
    ),
    "\n"
  )
  
  cat(
    "Documentos:",
    length(docs),
    "\n"
  )
  
  cat(
    "Termos distintos:",
    quantidade_vocab,
    "\n"
  )
  
  cat(
    "Corpus de brinquedo: 45 termos\n"
  )
  
  cat(
    "Corpus atual:",
    round(quantidade_vocab / 45, 1),
    "vezes maior\n"
  )
  
  cat("\n10 termos mais frequentes:\n\n")
  
  print(
    freq |>
      slice_head(n = 10)
  )
  
  cat("\n")
}


mostrar_documentos <- function() {
  cat("\n========================================\n")
  cat("DOCUMENTOS DO CORPUS\n")
  cat("========================================\n\n")
  
  for (i in seq_along(docs)) {
    cat(
      i,
      "-",
      names(docs)[i],
      "\n"
    )
  }
  
  cat("\n")
}


filtro_stopwords <- TRUE


repeat {
  cat("\n========================================\n")
  cat("MOTOR DE BUSCA - BAIXADA SANTISTA\n")
  cat("========================================\n")
  
  cat(
    "Stopwords:",
    ifelse(
      filtro_stopwords,
      "ATIVADAS",
      "DESATIVADAS"
    ),
    "\n\n"
  )
  
  cat("1 - Pesquisar\n")
  cat("2 - Ativar/desativar stopwords\n")
  cat("3 - Mostrar estatisticas\n")
  cat("4 - Mostrar documentos\n")
  cat("0 - Sair\n\n")
  
  opcao <- readline("Escolha uma opcao: ")
  
  
  if (opcao == "1") {
    consulta <- readline("Digite sua pesquisa: ")
    
    if (nchar(trimws(consulta)) == 0) {
      cat("\nDigite alguma palavra.\n")
      
    } else {
      resultado <- pesquisar(
        consulta,
        filtro_stopwords
      )
      
      if (!is.null(resultado)) {
        mostrar_frases(
          resultado$termos,
          resultado$resultados$documento
        )
      }
    }
    
    
  } else if (opcao == "2") {
    filtro_stopwords <- !filtro_stopwords
    
    cat(
      "\nStopwords agora estao:",
      ifelse(
        filtro_stopwords,
        "ATIVADAS",
        "DESATIVADAS"
      ),
      "\n"
    )
    
    
  } else if (opcao == "3") {
    mostrar_estatisticas(
      filtro_stopwords
    )
    
    
  } else if (opcao == "4") {
    mostrar_documentos()
    
    
  } else if (opcao == "0") {
    cat("\nPrograma encerrado.\n")
    break
    
    
  } else {
    cat("\nOpcao invalida.\n")
  }
}
