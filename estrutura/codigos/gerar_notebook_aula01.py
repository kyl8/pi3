import json

cells = [
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "# Projeto Integrador III — Aula 01\n",
            "## Do Problema da Busca ao Nosso Motor: Recuperação de Informação, Matriz Termo-Documento e Fundação do Projeto\n",
            "\n",
            "**Grupo:** APPA  \n",
            "**Integrantes:** Arthur Galvão, Pedro Henrique, Ailana  \n",
            "**Tema do Projeto:** Clubes Tradicionais de Futebol da Baixada Santista (Santos FC, Portuguesa Santista, Jabaquara AC)  \n",
            "**Repositório:** `https://github.com/kyl8/pi3`  \n",
            "**Data:** 2026-10-02"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "--- \n",
            "### Primeira Célula: Inicialização do Motor e Configuração do Ambiente\n",
            "Carregamento do contrato `motor01.R` e pacotes para coleta via API da Wikipédia."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# 1. Carregamento do motor da disciplina\n",
            "url_motor <- \"https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor01.R\"\n",
            "source(url_motor)\n",
            "\n",
            "# Pacotes necessarios para a Parte D (Wikipedia)\n",
            "if (!requireNamespace(\"httr2\", quietly = TRUE)) install.packages(\"httr2\")\n",
            "if (!requireNamespace(\"jsonlite\", quietly = TRUE)) install.packages(\"jsonlite\")\n",
            "library(httr2)\n",
            "\n",
            "# Criacao das pastas padronizadas do repositorio\n",
            "dir.create(\"estrutura/banco-de-dados\", recursive = TRUE, showWarnings = FALSE)\n",
            "dir.create(\"estrutura/codigo\",         recursive = TRUE, showWarnings = FALSE)\n",
            "dir.create(\"consolidado\",              recursive = TRUE, showWarnings = FALSE)\n",
            "\n",
            "cat(\"Motor carregado:\", MOTOR_VERSAO, \"\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "--- \n",
            "## PARTE A: TEORIA CANÔNICA (Módulos 1 a 10)\n",
            "\n",
            "### Módulo 1 — O que é Recuperação de Informação\n",
            "Diferença essencial entre **Banco de Dados Relacional** (busca booleana exata, onde registros satisfazem ou não um predicado sem ordenamento semântico) e **Recuperação de Informação (RI)** (busca sob incerteza, onde documentos são ordenados por grau estimado de relevância para atender a uma necessidade de informação)."
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 2 — Retrieve & Rerank (Dois Estágios)\n",
            "A arquitetura moderna de motores de busca divide a recuperação em:\n",
            "1. **Estágio 1 (Retrieve / Filtro Rápido):** Modelos lexicais e estruturados escaláveis (como índice invertido, BM25) que reduzem milhões de documentos a uma centena em frações de segundo.\n",
            "2. **Estágio 2 (Rerank / Ordenador Fino):** Modelos computacionalmente mais densos (como redes neurais profundas, cross-encoders) que analisam a centena selecionada e produzem o ranking final."
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 3 — O Corpus Canônico em R\n",
            "Definição do acervo didático de 8 sentenças (`d1` a `d8`), manipulado como vetor atômico nomeado."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Corpus canonico de 8 sentencas da Aula 01\n",
            "docs <- c(\n",
            "  d1 = \"recuperacao de informacao ordena documentos por relevancia\",\n",
            "  d2 = \"o modelo de espaco vetorial representa documentos como vetores\",\n",
            "  d3 = \"bm25 e um modelo probabilistico de ranqueamento de texto\",\n",
            "  d4 = \"aprendizado estatistico fundamenta a recuperacao moderna\",\n",
            "  d5 = \"o indice invertido acelera a busca em muitos documentos\",\n",
            "  d6 = \"embeddings capturam a semantica de palavras e documentos\",\n",
            "  d7 = \"a avaliacao mede a relevancia dos resultados da busca\",\n",
            "  d8 = \"ciencia de dados combina estatistica e programacao\"\n",
            ")\n",
            "\n",
            "cat(\"Total de documentos:\", length(docs), \"\\n\")\n",
            "print(docs[\"d1\"])"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 4 — Quebrando em Palavras: Tokenização\n",
            "Uso da função `tokenizar` para normalizar em caixa baixa e separar por espaços em branco, gerando uma lista `tokens`."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Tokenizacao funcional\n",
            "tokens <- lapply(docs, tokenizar)\n",
            "\n",
            "cat(\"Documento d1 possui\", length(tokens$d1), \"tokens:\\n\")\n",
            "print(tokens$d1)"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 5 — O Vocabulário e a Frequência Global\n",
            "Extração dos termos únicos do acervo com `unique` e contagem de ocorrências globais com `table`."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Vocabulario ordenado e frequencias no corpus\n",
            "vocab <- sort(unique(unlist(tokens)))\n",
            "freq  <- table(unlist(tokens))\n",
            "\n",
            "cat(\"Tamanho do vocabulario canonico:\", length(vocab), \"termos distintos.\\n\")\n",
            "cat(\"Top 6 termos mais frequentes no corpus:\\n\")\n",
            "print(head(sort(freq, decreasing = TRUE), 6))"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 6 — A Matriz Termo-Documento (TDM)\n",
            "Construção da representação matricial retangular ($45 \\times 8$) utilizando `factor(tk, levels = vocab)` para fixar as dimensões."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Construcao da Matriz Termo-Documento (TDM)\n",
            "tdm <- sapply(tokens, function(tk) {\n",
            "  as.integer(table(factor(tk, levels = vocab)))\n",
            "})\n",
            "rownames(tdm) <- vocab\n",
            "\n",
            "cat(\"Dimensoes da TDM:\", paste(dim(tdm), collapse = \" x \"), \"\\n\")\n",
            "cat(\"Amostra dos termos 'documentos', 'modelo', 'busca':\\n\")\n",
            "print(tdm[c(\"documentos\", \"modelo\", \"busca\"), ])"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 7 — A Primeira Busca: Booleana\n",
            "Recuperação de documentos que contêm um determinado termo e aplicação de consultas conjuntivas (operador AND) com `intersect`."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Funcao de busca booleana exata\n",
            "busca_booleana <- function(termo, tdm) {\n",
            "  termo <- tolower(termo)\n",
            "  if (!termo %in% rownames(tdm)) return(character(0))\n",
            "  colnames(tdm)[tdm[termo, ] > 0]\n",
            "}\n",
            "\n",
            "cat(\"Documentos com 'modelo':\", busca_booleana(\"modelo\", tdm), \"\\n\")\n",
            "cat(\"Documentos com 'documentos' E 'busca':\",\n",
            "    intersect(busca_booleana(\"documentos\", tdm), busca_booleana(\"busca\", tdm)), \"\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 8 — O Peso de um Termo: Frequência e Raridade (IDF)\n",
            "Cálculo do IDF clássico: $\\text{idf}_t = \\log(N / \\text{df}_t)$."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Frequencia documental (df) e IDF\n",
            "df  <- rowSums(tdm > 0)\n",
            "N   <- ncol(tdm)\n",
            "idf <- log(N / df)\n",
            "\n",
            "cat(\"Exemplos de IDF:\\n\")\n",
            "cat(\"df = 8 (termo ubíquo):\", idf[\"de\"], \"(peso nulo)\\n\")\n",
            "cat(\"df = 4 (documentos):\", round(idf[\"documentos\"], 4), \"\\n\")\n",
            "cat(\"df = 2 (busca):\", round(idf[\"busca\"], 4), \"\\n\")\n",
            "cat(\"df = 1 (estatistico):\", round(idf[\"estatistico\"], 4), \"\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 9 — A Matriz TF-IDF Completa\n",
            "Multiplicação matricial `tdm * idf` por reciclagem vetorial ao longo das colunas."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Calculo da matriz TF-IDF\n",
            "tfidf <- tdm * idf\n",
            "\n",
            "cat(\"TF-IDF do termo 'modelo' em d2 e d3:\", round(tfidf[\"modelo\", c(\"d2\", \"d3\")], 4), \"\\n\")\n",
            "cat(\"TF-IDF do termo 'de' em d1 e d2:\", round(tfidf[\"de\", c(\"d1\", \"d2\")], 4), \"\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 10 — O que o Motor É e o que Não É: Regex vs Motor\n",
            "Comparação entre busca sequencial por substring (`grep`) e recuperação formal por termos indexados (`busca_booleana`)."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Comparacao direta\n",
            "cat(\"grep('recupera', docs):\", grep(\"recupera\", docs), \"(acha substrings em d1 e d4)\\n\")\n",
            "cat(\"busca_booleana('recupera', tdm):\", busca_booleana(\"recupera\", tdm), \"(vazio: o termo exato nao existe no vocabulario)\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "--- \n",
            "## PARTE B: PRÁTICA EM GRUPO (Módulos 11 a 13 - Fundação do Projeto APPA)\n",
            "\n",
            "### Módulo 11 — Tema Regional, Usuário e Critério de Documento\n",
            "- **Tema:** Clubes Tradicionais de Futebol da Baixada Santista (Santos FC, Portuguesa Santista, Jabaquara AC).\n",
            "- **Usuário:** Pesquisadores, estudantes e jornalistas esportivos investigando a história dos clubes centenários de Santos.\n",
            "- **Três Perguntas Canônicas:**\n",
            "  1. Quando foi fundado o Santos Futebol Clube e quais seus primeiros títulos?\n",
            "  2. Qual o estádio e as cores da Portuguesa Santista?\n",
            "  3. Qual a trajetória histórica do Jabaquara Atlético Clube em Santos?\n",
            "- **Fonte:** Wikipédia em português (CC BY-SA 4.0).\n",
            "- **Documento:** Parágrafo (`\\n+`) com critério mínimo de 50 caracteres (`cfg$minimo = 50`)."
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 12 — Coleta e Persistência do Corpus Real\n",
            "Carregamento do `config.R` e leitura do corpus oficial gerado."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Leitura do config e dados do grupo\n",
            "source(\"estrutura/codigo/config.R\")\n",
            "docs_real   <- readRDS(\"estrutura/banco-de-dados/docs.rds\")\n",
            "origem_real <- readRDS(\"estrutura/banco-de-dados/origem.rds\")\n",
            "\n",
            "cat(\"Grupo:\", cfg$grupo, \"| Critério minimo:\", cfg$minimo, \"caracteres\\n\")\n",
            "cat(\"Total de documentos coletados:\", length(docs_real), \"\\n\")\n",
            "print(table(origem_real))"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### Módulo 13 — Cadeia de Indexação sobre o Corpus Real e Diagnóstico de Ruído"
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Indexacao do corpus real\n",
            "tokens_real <- lapply(docs_real, tokenizar)\n",
            "vocab_real  <- sort(unique(unlist(tokens_real)))\n",
            "freq_real   <- table(unlist(tokens_real))\n",
            "\n",
            "tdm_real <- sapply(tokens_real, function(tk) {\n",
            "  as.integer(table(factor(tk, levels = vocab_real)))\n",
            "})\n",
            "rownames(tdm_real) <- vocab_real\n",
            "\n",
            "tam_real <- sapply(tokens_real, length)\n",
            "cat(\"Estatisticas de tamanho dos documentos:\\n\")\n",
            "cat(\"Menor:\", min(tam_real), \"| Maior:\", max(tam_real), \"| Media:\", round(mean(tam_real)), \"tokens\\n\")\n",
            "cat(\"Tamanho do vocabulario bruto real:\", length(vocab_real), \"termos.\\n\\n\")\n",
            "\n",
            "cat(\"Top 10 termos mais frequentes no corpus real (presenca macica de stopwords e pontuacao):\\n\")\n",
            "print(head(sort(freq_real, decreasing = TRUE), 10))\n",
            "\n",
            "# Testes de busca booleana no acervo real\n",
            "cat(\"\\nDocumentos com 'santos':\", length(busca_booleana(\"santos\", tdm_real)), \"docs\\n\")\n",
            "cat(\"Documentos com 'pelé':\", length(busca_booleana(\"pelé\", tdm_real)), \"docs\\n\")\n",
            "cat(\"Documentos com 'briosa':\", length(busca_booleana(\"briosa\", tdm_real)), \"docs\\n\")"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "--- \n",
            "### Fechamento da Sessão e Inspeção do Estado\n",
            "Geração da fotografia do ambiente com a função `estado()` do motor."
        ]
    },
    {
        "cell_type": "code",
        "execution_count": None,
        "metadata": {},
        "outputs": [],
        "source": [
            "# Fotografia do ambiente R ao final da sessao\n",
            "estado()"
        ]
    }
]

notebook = {
    "cells": cells,
    "metadata": {
        "language_info": {
            "name": "R",
            "version": "4.6.1"
        },
        "kernelspec": {
            "display_name": "R",
            "language": "R",
            "name": "ir"
        }
    },
    "nbformat": 4,
    "nbformat_minor": 4
}

# Salva nas pastas correspondentes
with open("C:/Users/Arthur/Documents/IA_workspace/programacao/pi3/estrutura/codigos/Aula_01_Recuperacao_de_Informacao_e_Motor_de_Busca.ipynb", "w", encoding="utf-8") as f:
    json.dump(notebook, f, indent=2, ensure_ascii=False)

with open("C:/Users/Arthur/Documents/IA_workspace/programacao/pi3/estrutura/codigo/aula01.ipynb", "w", encoding="utf-8") as f:
    json.dump(notebook, f, indent=2, ensure_ascii=False)

print("Notebooks gerados com sucesso!")
