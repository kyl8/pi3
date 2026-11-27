library(shiny)
exemplos <- c("História do Santos" = "história santos futebol clube",
              "Estádio da Portuguesa Santista" = "portuguesa santista estádio",
              "Títulos do Santos" = "títulos santos",
              "Estádio do Jabaquara" = "estádio jabaquara")
ui <- fluidPage(
  tags$head(tags$title("Busca APPA · Projeto Integrador III"), tags$style(HTML("
  body{background:#f6efdf;color:#202c22;font-family:system-ui,sans-serif}
  .busca{max-width:1200px;margin:auto;padding:clamp(16px,4vw,45px)}
  .cabecalho{background:#15251e;color:#fff8e8;padding:26px 30px;border-radius:10px;margin-bottom:25px}
  .cabecalho h1{margin:6px 0 10px;font-weight:700}.cabecalho p{margin-bottom:0;color:#e3ebdf}
  .cabecalho small{color:#ffe097}.form-control,.btn{min-height:42px}
  .btn-primary,.btn-primary:focus,.btn-primary:hover{background:#21573f;border-color:#21573f}
  summary{cursor:pointer;padding:15px 0;font-weight:650}
  .lista{padding:0 18px;background:#fffbf1;border:1px solid #c5cdbc;border-radius:8px;margin-bottom:15px}
  .lista details+details{border-top:1px solid #ccd3c5}
  .lista p{line-height:1.55}.lista a{display:inline-block;margin-bottom:12px;color:#1c5d3c;text-decoration:underline}
  .resultado{padding:14px 16px;background:#e1eddb;border-left:4px solid #21573f;margin:10px 0}
  .mudanca{color:#355c47;font-size:.87em}.cred{color:#46584a;margin:24px 0 0}
  h2{font-size:22px}.form-group{width:100%}.row{margin-bottom:8px}
  :focus-visible{outline:3px solid #946500;outline-offset:3px}
  "))),
  div(class = "busca",
    tags$header(class = "cabecalho",
      tags$small("Projeto Integrador III · Grupo APPA"),
      h1("Busca sobre os clubes da Baixada Santista"),
      p(paste(length(documentos), "parágrafos · Santos FC, Portuguesa Santista e Jabaquara"))),
    fluidRow(
      column(7, textInput("consulta", "O que você quer encontrar?", value = exemplos[[1]], width = "100%"),
        actionButton("pesquisar", "Pesquisar", class = "btn-primary")),
      column(5, selectInput("exemplo", "Consultas para testar", c("Escolha um exemplo" = "", exemplos), width = "100%"))),
    fluidRow(
      column(4, selectInput("modelo", "Busca inicial", c("Híbrida (BM25 + LSA por RRF)" = "hibrido",
        "BM25" = "bm25", "LSA" = "lsa", "Cosseno TF-IDF" = "cosseno"))),
      column(4, selectInput("reordenacao", "Reordenar os 10 primeiros", c("Desligada" = "nenhuma",
        "MMR (diversidade)" = "mmr", "Proximidade de termos" = "proximidade"))),
      column(4, conditionalPanel("input.reordenacao === 'mmr'",
        sliderInput("lambda", "Peso da relevância (λ)", min = 0, max = 1, value = 0.7, step = 0.1),
        p("Em 1, fica a ordem inicial. Valores menores dão mais peso ao desconto por semelhança.")))),
    uiOutput("comparacao"),
    p(class = "cred", "Arthur Galvão · Pedro Henrique · Ailana Pereira Gonsalez · Prof. Dr. João Paulo Ferreira de Mello"),
    p(class = "cred", "Parágrafos da Wikipédia em português sob licença ",
      a("CC BY-SA 4.0", href = "https://creativecommons.org/licenses/by-sa/4.0/deed.pt-br"), ".")
  ),
  tags$script(HTML("(function() {
    const campo = document.getElementById('consulta');
    const enviar = () => Shiny.setInputValue('busca_pedido', campo.value, {priority:'event'});
    document.getElementById('pesquisar').addEventListener('click', enviar);
    campo.addEventListener('keydown', e => {
      if (e.key === 'Enter') { e.preventDefault(); enviar(); }
    });
  })();"))
)

server <- function(input, output, session) {
  observeEvent(input$exemplo, {
    if (nzchar(input$exemplo)) updateTextInput(session, "consulta", value = input$exemplo)
  })
  consulta <- reactive(if (is.null(input$busca_pedido)) exemplos[[1L]] else input$busca_pedido)
  resultado <- reactive(buscar(consulta(), input$modelo, input$reordenacao, input$lambda))
  lista <- function(ordem, inicial) {
    div(class = "lista", lapply(seq_along(head(ordem, 5)), function(pos) {
      id <- ordem[[pos]]
      antes <- match(id, inicial)
      clube <- clubes[[id]]
      pagina <- fontes[clube]
      tags$details(open = if (pos == 1L) "open" else NULL,
        tags$summary(paste(pos, "·", clube, "·", id),
          if (antes != pos) span(class = "mudanca", paste(" · era", antes))),
        p(documentos[[id]]),
        if (!is.na(pagina)) a("Fonte do parágrafo", href = paste0("https://pt.wikipedia.org/wiki/", pagina),
          target = "_blank", rel = "noopener noreferrer"))
    }))
  }
  output$comparacao <- renderUI({
    r <- resultado()
    if (!is.null(r$mensagem)) return(div(class = "resultado", role = "status", r$mensagem))
    fmt <- function(x) formatC(x, digits = 3, format = "f", decimal.mark = ",")
    comparar <- input$reordenacao != "nenhuma"
    tagList(
      div(class = "resultado", role = "status",
        strong(paste("Consulta:", consulta())),
        p(paste0("Semelhança do par mais parecido no top-3: ", fmt(r$redundancia[["antes"]]),
                 if (comparar) paste0(" → ", fmt(r$redundancia[["depois"]])) else "."),
          " Use a leitura dos resultados para avaliar o que mudou.")),
      if (comparar) fluidRow(
        column(6, h2("Busca inicial"), lista(r$inicial, r$inicial)),
        column(6, h2("Após a reordenação"), lista(r$final, r$inicial))
      ) else tagList(h2("Primeiros resultados"), lista(r$inicial, r$inicial))
    )
  })
}
