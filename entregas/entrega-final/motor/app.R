library(shiny)

exemplos <- c("Pelé no Santos" = "Pelé Santos",
              "Vila Belmiro" = "Vila Belmiro",
              "Portuguesa Santista · estádio" = "portuguesa santista estádio",
              "Jabaquara · história" = "história jabaquara")
lupa <- HTML('<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.7" aria-hidden="true"><circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 4.5 4.5" stroke-linecap="round"/></svg>')
marca <- tags$span("Busca", tags$b("APPA"), class = "wordmark")

ui <- fluidPage(title = "Busca APPA · Clubes da Baixada Santista", lang = "pt-BR",
  tags$head(tags$link(rel = "stylesheet", href = "appa/style.css")),
  tags$div(class = "busca",
    tags$header(class = "mast", a(class = "marca-link", href = "./", marca), span("Projeto Integrador III")),
    tags$main(
      tags$section(class = "entrada",
        h1(class = "landing-title", "Busca", tags$b("APPA")),
        p(class = "landing-sub", "Os clubes da Baixada Santista, parágrafo por parágrafo."),
        tags$form(id = "form-busca", role = "search", class = "search-box",
          span(class = "lupa", lupa),
          tags$input(id = "consulta", name = "q", type = "search", maxlength = 200,
            placeholder = "O que você quer encontrar?", `aria-label` = "Pesquisar no corpus", autocomplete = "off"),
          tags$button(type = "submit", id = "pesquisar", "Pesquisar")),
        div(class = "exemplos", lapply(seq_along(exemplos), function(i)
          tags$button(type = "button", class = "sugestao", `data-consulta` = unname(exemplos[i]), names(exemplos)[i])))),
      tags$details(class = "ajustes",
        tags$summary("Configurar a busca"),
        div(class = "config",
          selectInput("modelo", "Busca inicial", c("Híbrida (BM25 + LSA por RRF)" = "hibrido",
            "BM25" = "bm25", "LSA" = "lsa", "Cosseno TF-IDF" = "cosseno"), selectize = FALSE),
          selectInput("reordenacao", "Reordenar os 10 primeiros", c("Desligada" = "nenhuma",
            "MMR (diversidade)" = "mmr", "Proximidade de termos" = "proximidade"), selectize = FALSE),
          conditionalPanel("input.reordenacao === 'mmr'",
            sliderInput("lambda", "Peso da relevância (λ)", min = 0, max = 1, value = 0.7, step = 0.1),
            p(class = "ajuda", "Em 1, a ordem inicial é mantida.")))),
      uiOutput("comparacao")),
    tags$footer(class = "rodape",
      p(paste(length(documentos), "parágrafos de Santos FC, Portuguesa Santista e Jabaquara"),
        "· Wikipédia em português,",
        a("CC BY-SA 4.0", href = "https://creativecommons.org/licenses/by-sa/4.0/deed.pt-br",
          target = "_blank", rel = "noopener noreferrer")),
      p("Arthur Galvão · Pedro Henrique · Ailana Pereira Gonsalez · Prof. Dr. João Paulo Ferreira de Mello"))),
  tags$script(HTML("(function() {
    const campo = document.getElementById('consulta');
    const buscar = () => Shiny.setInputValue('busca_pedido', campo.value, {priority:'event'});
    document.getElementById('form-busca').addEventListener('submit', e => { e.preventDefault(); buscar(); });
    document.querySelectorAll('[data-consulta]').forEach(el => el.addEventListener('click', () => {
      campo.value = el.dataset.consulta;
      buscar();
    }));
  })();"))
)

# Preserva o corpus e corrige apenas os espaços da versão exibida.
texto_exibido <- function(texto) {
  texto <- gsub("[[:space:]]+([,.;:!?%])", "\\1", texto, perl = TRUE)
  texto <- gsub("([(]) +| +([)])", "\\1\\2", texto, perl = TRUE)
  trimws(gsub("[[:space:]]+", " ", texto, perl = TRUE))
}

sem_acentos <- function(palavras) tolower(iconv(palavras, to = "ASCII//TRANSLIT", sub = ""))

ocorrencias <- function(texto, termos) {
  pos <- gregexpr("[\\p{L}\\p{N}]+", texto, perl = TRUE)[[1]]
  if (pos[1] < 0L) return(data.frame(inicio = integer(), fim = integer()))
  fim <- pos + attr(pos, "match.length") - 1L
  palavras <- substring(texto, pos, fim)
  palavras <- sem_acentos(palavras)
  bateu <- palavras %in% termos
  data.frame(inicio = pos[bateu], fim = fim[bateu])
}

destacar <- function(texto, termos) {
  hits <- ocorrencias(texto, termos)
  if (!nrow(hits)) return(texto)
  partes <- character()
  atual <- 1L
  for (i in seq_len(nrow(hits))) {
    partes <- c(partes, htmltools::htmlEscape(substr(texto, atual, hits$inicio[i] - 1L)),
      paste0("<mark>", htmltools::htmlEscape(substr(texto, hits$inicio[i], hits$fim[i])), "</mark>"))
    atual <- hits$fim[i] + 1L
  }
  HTML(paste0(c(partes, htmltools::htmlEscape(substr(texto, atual, nchar(texto)))), collapse = ""))
}

trecho <- function(texto, termos) {
  hits <- ocorrencias(texto, termos)
  inicio <- if (nrow(hits)) max(1L, hits$inicio[1] - 65L) else 1L
  fim <- min(nchar(texto), inicio + 255L)
  parte <- substr(texto, inicio, fim)
  if (inicio > 1L) parte <- paste0("… ", sub("^\\S*\\s+", "", parte, perl = TRUE))
  if (fim < nchar(texto)) parte <- paste0(sub("\\s+\\S*$", "", parte, perl = TRUE), "…")
  parte
}

server <- function(input, output, session) {
  consulta <- reactive(input$busca_pedido)
  resultado <- reactive({
    req(!is.null(consulta()))
    buscar(consulta(), input$modelo, input$reordenacao, input$lambda)
  })
  limite <- reactiveVal(5L)
  observeEvent(input$busca_pedido, limite(5L))
  observeEvent(input$mais, limite(limite() + 5L))

  lista <- function(ordem, inicial, termos) {
    tags$ol(class = "resultados", lapply(seq_along(head(ordem, limite())), function(pos) {
      id <- ordem[[pos]]
      antes <- match(id, inicial)
      clube <- clubes[[id]]
      pagina <- fontes[clube]
      texto <- texto_exibido(documentos[[id]])
      primeira <- sub("^([^.!?]+[.!?]).*$", "\\1", texto, perl = TRUE)
      titulo <- if (nchar(primeira) <= 81L) primeira else
        paste0(sub("\\s+\\S*$", "", substr(primeira, 1, 78L), perl = TRUE), "…")
      tags$li(class = "resultado-item",
        div(class = "proveniencia", span(class = "posicao", pos), strong(clube), span(paste("Wikipédia ·", id)),
          if (antes != pos) span(class = "mudanca", paste("era", antes))),
        tags$details(class = "passagem",
          tags$summary(destacar(titulo, termos)),
          p(class = "integral", destacar(texto, termos)),
          if (!is.na(pagina)) a("Fonte online do parágrafo", class = "fonte",
            href = paste0("https://pt.wikipedia.org/wiki/", pagina),
            target = "_blank", rel = "noopener noreferrer")),
        p(class = "excerto", destacar(trecho(texto, termos), termos)))
    }))
  }
  output$comparacao <- renderUI({
    req(!is.null(consulta()))
    q <- trimws(consulta())
    r <- resultado()
    if (!is.null(r$mensagem)) {
      return(div(class = "with-results vazio", role = "status",
        h2(if (nzchar(q)) "Sem resultados" else "Digite uma busca"),
        p(if (nzchar(q)) "Tente outro termo, como o nome de um clube, jogador ou estádio.")))
    }
    fmt <- function(x) formatC(x, digits = 3, format = "f", decimal.mark = ",")
    comparar <- input$reordenacao != "nenhuma"
    # Realça a palavra digitada, mesmo se o ranking também considerar radicais.
    termos <- setdiff(strsplit(sem_acentos(q), "[^a-z0-9]+")[[1]], c(cfg$stopwords, ""))
    div(class = if (comparar) "with-results comparada" else "with-results",
      div(class = "resumo", role = "status",
        h2(paste0("Resultados para “", q, "”")),
        p(if (comparar) paste0("Semelhança do par mais parecido entre os três primeiros: ", fmt(r$redundancia[["antes"]]),
            " → ", fmt(r$redundancia[["depois"]]), ".") else "Abra um título para ler o parágrafo completo.")),
      if (comparar) div(class = "colunas",
        tags$section(h3("Ranking inicial"), lista(r$inicial, r$inicial, termos)),
        tags$section(h3(if (input$reordenacao == "mmr") "Com MMR" else "Com proximidade"),
          lista(r$final, r$inicial, termos)))
      else lista(r$inicial, r$inicial, termos),
      if (limite() < length(r$inicial)) actionButton("mais", "Mostrar mais resultados", class = "mais")
    )
  })
}
