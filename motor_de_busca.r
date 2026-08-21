baixar_wiki <- function(titulo) {
  titulo_url <- URLencode(titulo, reserved = TRUE)

  endereco <- paste0(
    "https://pt.wikipedia.org/w/index.php?title=",
    titulo_url,
    "&action=render"
  )

  linhas <- readLines(
    endereco,
    warn = FALSE,
    encoding = "UTF-8"
  )

  texto <- paste(linhas, collapse = " ")

  texto <- gsub(
    "<script[^>]*>.*?</script>",
    " ",
    texto,
    perl = TRUE
  )

  texto <- gsub(
    "<style[^>]*>.*?</style>",
    " ",
    texto,
    perl = TRUE
  )

  texto <- gsub(
    "<[^>]+>",
    " ",
    texto
  )

  texto <- gsub("&nbsp;", " ", texto, fixed = TRUE)
  texto <- gsub("&amp;", "&", texto, fixed = TRUE)
  texto <- gsub("&quot;", "\"", texto, fixed = TRUE)
  texto <- gsub("&#39;", "'", texto, fixed = TRUE)
  texto <- gsub("&#[0-9]+;", " ", texto)
  texto <- gsub("\\s+", " ", texto)

  trimws(texto)
}


cat("\nBaixando artigos da Wikipedia...\n")

docs <- c(
  "Santos FC" = baixar_wiki("Santos Futebol Clube"),
  "Portuguesa Santista" = baixar_wiki("Associação Atlética Portuguesa"),
  "Jabaquara" = baixar_wiki("Jabaquara Atlético Clube")
)

cat("Corpus carregado com sucesso.\n\n")


tokenizar <- function(texto) {
  texto <- tolower(texto)

  texto <- gsub(
    "[[:punct:]]+",
    " ",
    texto
  )

  texto <- gsub(
    "\\s+",
    " ",
    texto
  )

  tokens <- unlist(
    strsplit(
      trimws(texto),
      "\\s+"
    )
  )

  tokens[tokens != ""]
}


tokens <- lapply(
  docs,
  tokenizar
)


stopwords_pt <- c(
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
  "me", "te",
  "muito", "muita", "muitos", "muitas",
  "mesmo", "mesma",
  "durante", "desde",
  "sem", "sob"
)


preparar_tokens <- function(filtro_stopwords) {
  if (!filtro_stopwords) {
    return(tokens)
  }

  lapply(
    tokens,
    function(palavras) {
      palavras[
        !palavras %in% stopwords_pt
      ]
    }
  )
}


preparar_consulta <- function(
  consulta,
  filtro_stopwords
) {
  termos <- unique(
    tokenizar(consulta)
  )

  if (filtro_stopwords) {
    termos <- termos[
      !termos %in% stopwords_pt
    ]
  }

  termos
}


pesquisar <- function(
  consulta,
  filtro_stopwords
) {
  termos <- preparar_consulta(
    consulta,
    filtro_stopwords
  )

  if (length(termos) == 0) {
    cat(
      "\nNenhum termo valido para pesquisar.\n"
    )

    return(NULL)
  }

  tokens_ativos <- preparar_tokens(
    filtro_stopwords
  )

  ocorrencias <- sapply(
    tokens_ativos,
    function(palavras) {
      sum(
        palavras %in% termos
      )
    }
  )

  ocorrencias <- ocorrencias[
    ocorrencias > 0
  ]

  if (length(ocorrencias) == 0) {
    cat(
      "\nNenhum resultado encontrado.\n"
    )

    return(NULL)
  }

  ocorrencias <- sort(
    ocorrencias,
    decreasing = TRUE
  )

  resultados <- data.frame(
    posicao = seq_along(
      ocorrencias
    ),

    documento = names(
      ocorrencias
    ),

    ocorrencias = as.integer(
      ocorrencias
    ),

    row.names = NULL
  )

  cat("\n========================================\n")
  cat("RESULTADOS DA PESQUISA\n")
  cat("========================================\n")

  cat(
    "Pesquisa:",
    consulta,
    "\n"
  )

  cat(
    "Termos considerados:",
    paste(
      termos,
      collapse = ", "
    ),
    "\n\n"
  )

  print(
    resultados,
    row.names = FALSE
  )

  list(
    resultados = resultados,
    termos = termos
  )
}


mostrar_frases <- function(
  termos,
  documentos_encontrados
) {
  cat("\n========================================\n")
  cat("FRASES ENCONTRADAS\n")
  cat("========================================\n")

  total <- 0

  for (
    documento in documentos_encontrados
  ) {
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

    frases <- frases[
      nchar(frases) > 0
    ]

    frases_encontradas <- c()

    for (frase in frases) {
      palavras_frase <- tokenizar(
        frase
      )

      if (
        any(
          palavras_frase %in% termos
        )
      ) {
        frases_encontradas <- c(
          frases_encontradas,
          frase
        )
      }
    }

    if (
      length(frases_encontradas) > 0
    ) {
      cat("\n----------------------------------------\n")
      cat(documento, "\n")
      cat("----------------------------------------\n")

      for (
        i in seq_along(
          frases_encontradas
        )
      ) {
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
    cat(
      "\nNenhuma frase encontrada.\n"
    )
  }

  cat("\n")
}


mostrar_estatisticas <- function(
  filtro_stopwords
) {
  tokens_ativos <- preparar_tokens(
    filtro_stopwords
  )

  todos_tokens <- unlist(
    tokens_ativos
  )

  vocab <- unique(
    todos_tokens
  )

  frequencia <- sort(
    table(todos_tokens),
    decreasing = TRUE
  )

  quantidade_vocab <- length(
    vocab
  )

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
    "Tokens:",
    length(todos_tokens),
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
    round(
      quantidade_vocab / 45,
      1
    ),
    "vezes maior\n"
  )

  cat(
    "\n10 termos mais frequentes:\n\n"
  )

  print(
    head(
      frequencia,
      10
    )
  )

  cat("\n")
}


mostrar_documentos <- function() {
  cat("\n========================================\n")
  cat("DOCUMENTOS DO CORPUS\n")
  cat("========================================\n\n")

  for (
    i in seq_along(docs)
  ) {
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

  opcao <- readline(
    "Escolha uma opcao: "
  )


  if (opcao == "1") {
    consulta <- readline(
      "Digite um ou mais termos: "
    )

    if (
      nchar(
        trimws(consulta)
      ) == 0
    ) {
      cat(
        "\nDigite alguma palavra.\n"
      )

    } else {
      resultado <- pesquisar(
        consulta,
        filtro_stopwords
      )

      if (
        !is.null(resultado)
      ) {
        mostrar_frases(
          resultado$termos,
          resultado$resultados$documento
        )
      }
    }


  } else if (opcao == "2") {
    filtro_stopwords <-
      !filtro_stopwords

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
    cat(
      "\nPrograma encerrado.\n"
    )

    break


  } else {
    cat(
      "\nOpcao invalida.\n"
    )
  }
}
