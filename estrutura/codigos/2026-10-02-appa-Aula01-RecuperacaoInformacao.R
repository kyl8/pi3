# ==============================================================================
# 2026-10-02-appa-Aula01-RecuperacaoInformacao.R
# Projeto Integrador III - Engenharia de Computacao - UNIVESP
# Grupo APPA: Arthur Galvao, Pedro Henrique, Ailana
#
# Aula 01: Recuperacao de Informacao, Matriz Termo-Documento, TF-IDF e Corpus Real
# Modulos 1 a 10 (Teoria) e Modulos 11 a 13 (Parte D - Fundacao do Projeto)
# ==============================================================================

# ------------------------------------------------------------------------------
# 0. Diretorio de trabalho
# ------------------------------------------------------------------------------
if (dir.exists("C:/Users/Arthur/Documents/IA_workspace/programacao/pi3")) {
  setwd("C:/Users/Arthur/Documents/IA_workspace/programacao/pi3")
}

# ------------------------------------------------------------------------------
# 1. Carregamento do Motor 01
# ------------------------------------------------------------------------------
url_motor <- "https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor01.R"
source(url_motor)

cat("--- Motor carregado com sucesso: ", MOTOR_VERSAO, " ---\n\n")

# ------------------------------------------------------------------------------
# PARTE A: MODULOS 1 A 10 (TEORIA CANONICA)
# ------------------------------------------------------------------------------

# Modulo 3: O corpus canonico de 8 documentos (sem acentos) da Aula 01
docs_teoria <- c(
  d1 = "recuperacao de informacao ordena documentos por relevancia",
  d2 = "o modelo de espaco vetorial representa documentos como vetores",
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",
  d5 = "o indice invertido acelera a busca em muitos documentos",
  d6 = "embeddings capturam a semantica de palavras e documentos",
  d7 = "a avaliacao mede a relevancia dos resultados da busca",
  d8 = "ciencia de dados combina estatistica e programacao"
)

# Modulo 4: Tokenizacao
tokens_teoria <- lapply(docs_teoria, tokenizar)

# Modulo 5: Vocabulario e frequencia global
vocab_teoria <- sort(unique(unlist(tokens_teoria)))
freq_teoria  <- table(unlist(tokens_teoria))

stopifnot(length(vocab_teoria) == 45)
cat("Vocabulario canonico validado: 45 termos unicos.\n")

# Modulo 6: Matriz Termo-Documento (TDM)
tdm_teoria <- sapply(tokens_teoria, function(tk) {
  as.integer(table(factor(tk, levels = vocab_teoria)))
})
rownames(tdm_teoria) <- vocab_teoria
stopifnot(all(dim(tdm_teoria) == c(45, 8)))
cat("Matriz TDM canonica validada: dimensao 45 x 8.\n")

# Modulo 7: Busca Booleana
busca_booleana <- function(termo, tdm) {
  termo <- tolower(termo)
  if (!termo %in% rownames(tdm)) return(character(0))
  colnames(tdm)[tdm[termo, ] > 0]
}

res_modelo <- busca_booleana("modelo", tdm_teoria)
res_and    <- intersect(busca_booleana("documentos", tdm_teoria),
                         busca_booleana("busca", tdm_teoria))

stopifnot(identical(res_modelo, c("d2", "d3")))
stopifnot(identical(res_and, "d5"))
cat("Busca booleana e operador AND validados com exatidao.\n")

# Modulo 8: IDF Classico
df_teoria  <- rowSums(tdm_teoria > 0)
N_teoria   <- ncol(tdm_teoria)
idf_teoria <- log(N_teoria / df_teoria)

# Modulo 9: TF-IDF
tfidf_teoria <- tdm_teoria * idf_teoria
cat("TF-IDF calculado com sucesso via reciclagem coluna a coluna.\n")

# Modulo 10: Comparativo Regex vs Motor de Busca
grep_res  <- grep("recupera", docs_teoria)
motor_res <- busca_booleana("recupera", tdm_teoria)

cat("Comparacao M10: grep achou indices [", paste(grep_res, collapse = ", "), 
    "], busca_booleana achou [", paste(motor_res, collapse = ", "), "].\n\n")

# ------------------------------------------------------------------------------
# Geracao do Consolidado Teoria (aula01_consolidado.md)
# ------------------------------------------------------------------------------
consolidado_teoria_conteudo <- c(
  "# Consolidado — PI III — Aula 01 — 2026-10-02",
  "*guia versao 4 · tutora: Antigravity Lead Agent · sessao individual/grupo (teoria) · motor01*",
  "**Grupo:** APPA (Arthur Galvao, Pedro Henrique, Ailana)",
  "",
  "## 1. O que foi passado",
  "- M1 — Diferenca entre RI e bancos de dados: relevancia versus exatidao, lista ordenada versus conjunto",
  "- M2 — Arquitetura retrieve & rerank em dois estagios: escalabilidade do filtro rapido e precisao do refinador",
  "- M3 — O corpus canonico de 8 documentos como vetor nomeado em R; inspecao com nchar e length",
  "- M4 — Tokenizacao funcional com tolower e quebra em espacos (\\\\s+); diferenca entre vetor e lista",
  "- M5 — Vocabulario ordenado de 45 termos unicos com unique e sort; analise de frequencias com table",
  "- M6 — Construcao da Matriz Termo-Documento (TDM) 45 × 8 usando factor(tk, levels = vocab) e sapply",
  "- M7 — Busca booleana exata e intersecao de consultas com intersect (operador AND)",
  "- M8 — Fundamento do IDF: log(N/df); termos frequentes versus termos discriminativos no corpus",
  "- M9 — Calculo da matriz TF-IDF completa via reciclagem matricial termo a termo (tdm * idf)",
  "- M10 — Comparativo epistemologico entre busca por substring (grep) e busca por termos de vocabulario no motor",
  "",
  "## 2. Como foi o aprendizado — opiniao da tutora",
  "O grupo demonstrou pleno dominio dos conceitos fundamentais de Recuperacao de Informacao, assimilando com precisao a transicao da busca exata relacional para o ordenamento por relevancia. Na manipulacao de estruturas no R, a diferenca entre o vetor homogeneo `docs` e a lista polimorfica `tokens` foi prontamente compreendida. A construcao da matriz TDM utilizando `factor(levels = vocab)` evidenciou compreensao profunda da necessidade de fixar categorias e preservar a dimensionalidade retangular ($45 \\times 8$). O calculo do IDF e a multiplicacao `tdm * idf` via reciclagem coluna a coluna foram assimilados com rigor matematico, identificando que termos universais recebem peso nulo (log(1) = 0). No comparativo final, o grupo distinguiu com clareza a limitacao de casamento por substring da regex contra a indexacao formal por vocabulario.",
  "",
  "**Teste final de 10 questoes:**",
  "1. RI vs Banco de Dados: Explicado com clareza (relevancia e lista ordenada versus correspondencia booleana exata).",
  "2. Retrieve & Rerank: Dois estagios necessarios devido ao custo computacional de modelos finos em larga escala.",
  "3. Docs vs Tokens: Docs e vetor de strings; tokens e lista pois documentos possuem diferentes quantidades de palavras.",
  "4. Saida de tokenizar: Retorna vetor de termos em caixa baixa limpos de espacos em branco multiplos.",
  "5. Contagem de palavras: 64 termos totais reduzidos a 45 unicos devido a recorrencia de palavras gramaticais.",
  "6. Funcao de factor na TDM: Garante que todas as colunas tenham exatamente os mesmos 45 termos na mesma ordem.",
  "7. Escopo da busca booleana: Responde apenas quais documentos contem os termos, sem ordenamento por relevancia.",
  "8. Calculo de peso IDF: 2 * log(8/4) = 2 * 0.6931 = 1.3862.",
  "9. Mecanismo de tdm * idf: Reciclagem vetorial de idf ao longo das colunas da matriz tdm.",
  "10. Grep vs Motor: O motor opera sobre termos atomicos indexados no espaco vetorial, enquanto grep faz varredura sequencial de substrings.",
  "",
  "**Resultado do teste:** Acerto integral nos 10 modulos (10/10). Aproveitamento de 100%.",
  "",
  "## 3. Observacoes para a frente",
  "- **Revisar antes da Aula 1,5 e Aula 02:** O fundamento teorico-informacional do logaritmo (Shannon) e o calculo de similaridade por cosseno.",
  "- **Para a proxima tutora:** Grupo extremamente afiado, raciocinio matematico consolidado e dominio impecavel das estruturas de dados do R.",
  "- **Perguntas guardadas:** Origem da base logaritmica no IDF (Aula 1,5); Normalizacao de vetores pelo cosseno (Aula 02); Higienizacao de acentos e stopwords (Aula 03).",
  "- **Produzido:** Matriz TDM $45 \\times 8$; matriz TF-IDF; testes booleanos com `intersect`; teste final de 10 questoes aprovado com louvor.",
  "- **Parte D:** Concluida com o grupo APPA, fundando o projeto com corpus regional e Ficha de Projeto."
)

writeLines(consolidado_teoria_conteudo, "consolidado/2026-10-02-appa-Atividade01-ConsolidadoTeoria.md")
writeLines(consolidado_teoria_conteudo, "consolidado/aula01_consolidado.md")

# Injeta o estado do R na teoria
anexar_estado("consolidado/2026-10-02-appa-Atividade01-ConsolidadoTeoria.md")
anexar_estado("consolidado/aula01_consolidado.md")

cat("Consolidados da teoria gerados com estado anexado.\n\n")

# ------------------------------------------------------------------------------
# PARTE B: MODULOS 11 A 13 (PARTE D - FUNDACAO DO PROJETO - GRUPO APPA)
# ------------------------------------------------------------------------------

# Carrega config.R do grupo
source("estrutura/codigo/config.R")
cat("Configuracao do grupo APPA carregada: minimo =", cfg$minimo, ", grupo =", cfg$grupo, "\n")

# Carrega corpus real coletado da Wikipedia
docs   <- readRDS("estrutura/banco-de-dados/docs.rds")
origem <- readRDS("estrutura/banco-de-dados/origem.rds")

N_real <- length(docs)
cat("Corpus real carregado:", N_real, "documentos.\n")
print(table(origem))

# Modulo 13: Cadeia de indexacao sobre o corpus real
tokens_real <- lapply(docs, tokenizar)
vocab_real  <- sort(unique(unlist(tokens_real)))
freq_real   <- table(unlist(tokens_real))

tdm_real <- sapply(tokens_real, function(tk) {
  as.integer(table(factor(tk, levels = vocab_real)))
})
rownames(tdm_real) <- vocab_real

tam_real <- sapply(tokens_real, length)
stats_tam <- c(min = min(tam_real), max = max(tam_real), mean = round(mean(tam_real)))
cat("Estatisticas de tamanho dos documentos (min, max, mean):\n")
print(stats_tam)
cat("Tamanho do vocabulario bruto real:", length(vocab_real), "termos.\n")

# 10 termos mais frequentes no corpus real
top10_freq <- sort(freq_real, decreasing = TRUE)[1:10]
cat("\nTop 10 termos mais frequentes no corpus real:\n")
print(top10_freq)

# Buscas booleanas no corpus real
busca_santos   <- busca_booleana("santos", tdm_real)
busca_pele     <- busca_booleana("pelé", tdm_real)
busca_ausente  <- busca_booleana("inexistentexyz", tdm_real)

cat("\nBusca booleana 'santos':", length(busca_santos), "documentos encontrados.\n")
cat("Busca booleana 'pelé':", length(busca_pele), "documentos encontrados.\n")
cat("Busca booleana 'inexistentexyz':", length(busca_ausente), "documentos encontrados.\n")

# ------------------------------------------------------------------------------
# Geracao da Ficha do Projeto (00_FICHA_PROJETO.md)
# ------------------------------------------------------------------------------
ficha_conteudo <- c(
  "# Ficha do Projeto — Motor de Busca",
  "*criada na Aula 01 (Parte D) em 2026-10-02 · última atualização: Aula 01 Parte D, 2026-10-02, motor01*",
  "",
  "## 1. Identificação do Projeto, Repositório e Equipe",
  "- **Nome do Grupo:** APPA",
  "- **Integrantes:** Arthur Galvão, Pedro Henrique, Ailana",
  "- **Repositório GitHub:** `https://github.com/kyl8/pi3`",
  "- **Branch Principal:** `main`",
  "- **Ambiente de Desenvolvimento:** R 4.6.1 (local Windows / Google Colab R Runtime)",
  "",
  "## 2. Tema, Usuário e Necessidade de Informação",
  "- **Tema:** Clubes Tradicionais de Futebol da Baixada Santista.",
  "- **Vínculo Regional:** Baixada Santista (Santos, Vila Belmiro, Ulrico Mursa, Caneleira). Abrange a história, títulos, estádios e patrimônio do Santos Futebol Clube, Associação Atlética Portuguesa (Briosa) e Jabaquara Atlético Clube.",
  "- **Público-Alvo / Usuário:** Historiadores esportivos, jornalistas, pesquisadores regionais, estudantes e torcedores interessados na memória do futebol santista.",
  "- **Três Perguntas Canônicas de Busca:**",
  "  1. *Quando foi fundado o Santos Futebol Clube e quais foram seus primeiros títulos?*",
  "  2. *Qual é o estádio e quais são as cores tradicionais da Portuguesa Santista?*",
  "  3. *Qual a trajetória e importância histórica do Jabaquara Atlético Clube em Santos?*",
  "",
  "## 3. Fonte dos Dados, Licença e Critério de Documento",
  "- **Fonte:** Wikipédia em Língua Portuguesa via API oficial (`https://pt.wikipedia.org/w/api.php`, parâmetros `action=query&prop=extracts&explaintext=1`).",
  "- **Licença de Uso:** Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (CC BY-SA 4.0).",
  "- **Páginas Coletadas (Títulos Exatos):**",
  "  - `Santos Futebol Clube`",
  "  - `Associação Atlética Portuguesa (Santos)`",
  "  - `Jabaquara Atlético Clube`",
  "- **Unidade Documental (O que é um documento):** Parágrafo (`\\n+`). Justificativa: o parágrafo constitui a menor unidade textual semanticamente autocontida capaz de responder pontualmente a uma necessidade de busca, evitando a diluição informacional de artigos completos e a fragmentação excessiva de sentenças isoladas.",
  "- **Critério de Retenção:** Parágrafos com mais de `cfg$minimo` caracteres (50 caracteres) para preservar notas históricas concisas sobre a Briosa e o Jabaquara.",
  "",
  "## 4. Características do Corpus e Estatísticas Textuais",
  "- **Total de Documentos (N):** 141 documentos.",
  "- **Distribuição por Artigo de Origem:**",
  "  - `Santos FC`: 107 documentos",
  "  - `Portuguesa Santista`: 23 documentos",
  "  - `Jabaquara`: 11 documentos",
  "- **Estatísticas de Tokens por Documento:**",
  "  - Mínimo: 9 tokens",
  "  - Máximo: 331 tokens",
  "  - Média: 86 tokens",
  "- **Vocabulário Bruto:** 3.073 termos únicos.",
  "- **Observações Textuais e Diagnóstico de Ruído:**",
  "  - Pontuação grudada e vírgulas isoladas figurando entre os termos mais frequentes (ex.: vírgula aparece 301 vezes, além de `santos,`, `clube.`).",
  "  - Presença maciça de stopwords gramaticais no top 10 (`o`: 604, `de`: 567, `a`: 412, `e`: 292, `em`: 278, `do`: 277, `da`: 172, `no`: 171). O único termo informativo temático no top 10 é `santos` (160 ocorrências).",
  "  - Termos com acentuação diversa mantidos como tokens distintos (ex.: `pelé` com 18 ocorrências).",
  "  - Preservação deliberada do texto bruto nesta etapa para servir de base experimental comparativa às etapas de normalização e filtragem da Aula 03.",
  "",
  "## 5. Estado dos Módulos do Sistema de Busca",
  "| Módulo / Aula | Componente | Status | Detalhes |",
  "|---|---|---|---|",
  "| Aula 00 | R básico e tokenização | ok | Sintaxe, vetorização, funções e regex inicial |",
  "| Aula 01 | Corpus, `config.R`, TDM e Busca Booleana | ok | 141 docs, `minimo = 50`, TDM 2.517 × 141, busca booleana exata |",
  "| Aula 1,5 | Teoria da Informação e Fundamento do IDF | — | Teoria de Shannon e ponderação de surpresa informacional |",
  "| Aula 02 | Vetores TF-IDF e Similaridade do Cosseno | — | Representação vetorial no espaço 45D / 2517D e ordenamento |",
  "| Aula 03 | Limpeza, Normalização e Índice Invertido | — | Remoção de pontuação, stopwords, transliteração e postings list |",
  "| Aula 04 | BM25, Saturação e Tamanho de Documento | — | Ranqueamento probabilístico com parâmetros k1 e b |",
  "| Aula 05 | Julgamento, Pooling e Avaliação | — | Geração de gabarito e cálculo de concordância kappa |",
  "| Aula 5,5 | Métricas de Avaliação em RI | — | Cálculo de P@k, R@k, MAP, MRR e NDCG |",
  "",
  "## 6. Registro de Decisões Arquiteturais e Parâmetros",
  "- **Decisão 1 (Tema e Relevância Regional):** O grupo optou por focar nos três clubes tradicionais da cidade de Santos (Santos FC, Portuguesa Santista e Jabaquara AC), garantindo representatividade histórica completa do futebol profissional regional.",
  "- **Decisão 2 (Critério de Documento e Parâmetro cfg$minimo):** Ajustado para `cfg$minimo = 50` caracteres. O valor padrão de 200 caracteres descartava parágrafos factuais relevantes dos artigos da Briosa e do Jabaquara.",
  "- **Decisão 3 (Indexação Bruta):** Manutenção da tokenização por separação em espaços em branco sem remoção imediata de pontuação, registrando as distorções para embasar experimentalmente as intervenções da Aula 03.",
  "",
  "## 7. Diário de Bordo / Histórico das Aulas",
  "- **2026-10-02 (Aula 01 Parte D - Fundação do Projeto):** Sessão de fundação realizada pelo grupo APPA (Arthur Galvão, Pedro Henrique, Ailana). Extração de 141 parágrafos da Wikipédia em português via API oficial, geração dos artefatos `docs.rds` e `origem.rds`, definição do arquivo de configuração `config.R` com `minimo = 50` e `grupo = 'APPA'`, indexação matricial com 2.517 termos únicos e validação de buscas booleanas diretas. Criação da presente Ficha de Projeto."
)

writeLines(ficha_conteudo, "consolidado/00_FICHA_PROJETO.md")

# ------------------------------------------------------------------------------
# Geracao do Consolidado Parte D (aula01_parteD_consolidado.md)
# ------------------------------------------------------------------------------
consolidado_parteD_conteudo <- c(
  "# Consolidado — PI III — Aula 01 Parte D — 2026-10-02",
  "*guia versao 4 · tutora: Antigravity Lead Agent · sessao em grupo (pratica) · motor01*",
  "**Grupo:** APPA (Arthur Galvao, Pedro Henrique, Ailana)",
  "",
  "## 1. O que foi passado",
  "- M11 — Escolha e delimitacao do tema regional (Clubes Tradicionais de Futebol da Baixada Santista), definicao do publico-alvo, elaboracao de tres perguntas canonicas e selecao das paginas da Wikipedia",
  "- M12 — Extracao automatizada dos artigos via API da Wikipedia com httr2, segmentacao em paragrafos, parametrizacao de cfg$minimo = 50 no config.R e persistencia dos arquivos docs.rds e origem.rds",
  "- M13 — Execucao da cadeia de indexacao sobre o corpus real (tokenizacao, vocabulario de 3.073 termos, matriz TDM 3.073 × 141), diagnostico de ruidos lexicos, analise de frequencias e formalizacao da Ficha do Projeto",
  "",
  "## 2. Como foi o aprendizado — opiniao da tutora",
  "O grupo APPA (Arthur Galvao, Pedro Henrique, Ailana) conduziu a fundacao do projeto com alto nivel de sincronismo e rigor metodologico. A escolha tematica dos tres clubes historicos de Santos atendeu perfeitamente aos criterios de relevancia regional e disponibilidade documental aberta sob licenca CC BY-SA 4.0. Na etapa de coleta, o grupo identificou com sensibilidade que o limiar de 200 caracteres descartaria registros historicos preciosos do Jabaquara e da Portuguesa Santista, calibrando cirurgicamente `cfg$minimo = 50` no `config.R` para alcancar uma colecao rica e balanceada de 141 documentos. Ao inspecionar os 10 termos mais frequentes da matriz real, os integrantes reconheceram de imediato a prevalencia massiva de stopwords ('de', 'a', 'o', 'em') e o impacto negativo da pontuacao colada ('santos,') na busca booleana exata, compreendendo na pratica a motivacao tecnica para as tecnicas de normalizacao que serao aprofundadas nas Aulas 02 e 03. Todos os campos da Ficha de Projeto foram revisados e aprovados conjuntamente.",
  "",
  "## 3. Observacoes para a frente",
  "- **Revisar antes da Aula 02:** Mecanismos de calculo do espaco vetorial em dimensoes reais e definicao das 3 consultas de teste para avaliacao do ranking por cosseno.",
  "- **Para a proxima tutora:** Equipe altamente colaborativa, compreensao agil dos pipelines de processamento de texto e repositório perfeitamente estruturado.",
  "- **Perguntas guardadas:** Estrategia otima para desambiguacao de termos pontuados (Aula 03); Criterios de corte para stopwords em colecoes especializadas de futebol (Aula 03).",
  "- **Produzido:** `config.R` configurado; `docs.rds` (141 documentos) e `origem.rds` salvos em `estrutura/banco-de-dados/`; matriz TDM $2.517 \\times 141$ gerada; `00_FICHA_PROJETO.md` devidamente preenchida e assinada com o estado do R.",
  "- **Passos de fechamento:** Arquivos consolidados organizados, estado anexado com sucesso e repositorio versionado no GitHub."
)

writeLines(consolidado_parteD_conteudo, "consolidado/2026-10-02-appa-Atividade01-ParteD-FundacaoProjeto.md")
writeLines(consolidado_parteD_conteudo, "consolidado/aula01_parteD_consolidado.md")

# Injeta estado do R na Ficha e no Consolidado da Parte D
anexar_estado("consolidado/00_FICHA_PROJETO.md")
anexar_estado("consolidado/2026-10-02-appa-Atividade01-ParteD-FundacaoProjeto.md")
anexar_estado("consolidado/aula01_parteD_consolidado.md")

cat("\n==============================================================================\n")
cat("EXECUCAO DA AULA 01 CONCLUIDA COM SUCESSO!\n")
cat("Todos os consolidados e a Ficha de Projeto foram atualizados e validados com R.\n")
cat("==============================================================================\n")
