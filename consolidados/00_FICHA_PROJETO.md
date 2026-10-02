# Ficha do Projeto — Motor de Busca
*criada na Aula 01 (Parte D) em 2026-10-02 · última atualização: Aula 01 Parte D, 2026-10-02, motor01*

## 1. Identificação do Projeto, Repositório e Equipe
- **Nome do Grupo:** APPA
- **Integrantes:** Arthur Galvão, Pedro Henrique, Ailana
- **Repositório GitHub:** `https://github.com/kyl8/pi3`
- **Branch Principal:** `main`
- **Ambiente de Desenvolvimento:** R 4.6.1 (local Windows / Google Colab R Runtime)

## 2. Tema, Usuário e Necessidade de Informação
- **Tema:** Clubes Tradicionais de Futebol da Baixada Santista.
- **Vínculo Regional:** Baixada Santista (Santos, Vila Belmiro, Ulrico Mursa, Caneleira). Abrange a história, títulos, estádios e patrimônio do Santos Futebol Clube, Associação Atlética Portuguesa (Briosa) e Jabaquara Atlético Clube.
- **Público-Alvo / Usuário:** Historiadores esportivos, jornalistas, pesquisadores regionais, estudantes e torcedores interessados na memória do futebol santista.
- **Três Perguntas Canônicas de Busca:**
  1. *Quando foi fundado o Santos Futebol Clube e quais foram seus primeiros títulos?*
  2. *Qual é o estádio e quais são as cores tradicionais da Portuguesa Santista?*
  3. *Qual a trajetória e importância histórica do Jabaquara Atlético Clube em Santos?*

## 3. Fonte dos Dados, Licença e Critério de Documento
- **Fonte:** Wikipédia em Língua Portuguesa via API oficial (`https://pt.wikipedia.org/w/api.php`, parâmetros `action=query&prop=extracts&explaintext=1`).
- **Licença de Uso:** Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (CC BY-SA 4.0).
- **Páginas Coletadas (Títulos Exatos):**
  - `Santos Futebol Clube`
  - `Associação Atlética Portuguesa (Santos)`
  - `Jabaquara Atlético Clube`
- **Unidade Documental (O que é um documento):** Parágrafo (`\n+`). Justificativa: o parágrafo constitui a menor unidade textual semanticamente autocontida capaz de responder pontualmente a uma necessidade de busca, evitando a diluição informacional de artigos completos e a fragmentação excessiva de sentenças isoladas.
- **Critério de Retenção:** Parágrafos com mais de `cfg$minimo` caracteres (50 caracteres) para preservar notas históricas concisas sobre a Briosa e o Jabaquara.

## 4. Características do Corpus e Estatísticas Textuais
- **Total de Documentos (N):** 141 documentos.
- **Distribuição por Artigo de Origem:**
  - `Santos FC`: 107 documentos
  - `Portuguesa Santista`: 23 documentos
  - `Jabaquara`: 11 documentos
- **Estatísticas de Tokens por Documento:**
  - Mínimo: 9 tokens
  - Máximo: 331 tokens
  - Média: 86 tokens
- **Vocabulário Bruto:** 3.073 termos únicos.
- **Observações Textuais e Diagnóstico de Ruído:**
  - Pontuação grudada e vírgulas isoladas figurando entre os termos mais frequentes (ex.: vírgula aparece 301 vezes, além de `santos,`, `clube.`).
  - Presença maciça de stopwords gramaticais no top 10 (`o`: 604, `de`: 567, `a`: 412, `e`: 292, `em`: 278, `do`: 277, `da`: 172, `no`: 171). O único termo informativo temático no top 10 é `santos` (160 ocorrências).
  - Termos com acentuação diversa mantidos como tokens distintos (ex.: `pelé` com 18 ocorrências).
  - Preservação deliberada do texto bruto nesta etapa para servir de base experimental comparativa às etapas de normalização e filtragem da Aula 03.

## 5. Estado dos Módulos do Sistema de Busca
| Módulo / Aula | Componente | Status | Detalhes |
|---|---|---|---|
| Aula 00 | R básico e tokenização | ok | Sintaxe, vetorização, funções e regex inicial |
| Aula 01 | Corpus, `config.R`, TDM e Busca Booleana | ok | 141 docs, `minimo = 50`, TDM 2.517 × 141, busca booleana exata |
| Aula 1,5 | Teoria da Informação e Fundamento do IDF | — | Teoria de Shannon e ponderação de surpresa informacional |
| Aula 02 | Vetores TF-IDF e Similaridade do Cosseno | — | Representação vetorial no espaço 45D / 2517D e ordenamento |
| Aula 03 | Limpeza, Normalização e Índice Invertido | — | Remoção de pontuação, stopwords, transliteração e postings list |
| Aula 04 | BM25, Saturação e Tamanho de Documento | — | Ranqueamento probabilístico com parâmetros k1 e b |
| Aula 05 | Julgamento, Pooling e Avaliação | — | Geração de gabarito e cálculo de concordância kappa |
| Aula 5,5 | Métricas de Avaliação em RI | — | Cálculo de P@k, R@k, MAP, MRR e NDCG |

## 6. Registro de Decisões Arquiteturais e Parâmetros
- **Decisão 1 (Tema e Relevância Regional):** O grupo optou por focar nos três clubes tradicionais da cidade de Santos (Santos FC, Portuguesa Santista e Jabaquara AC), garantindo representatividade histórica completa do futebol profissional regional.
- **Decisão 2 (Critério de Documento e Parâmetro cfg$minimo):** Ajustado para `cfg$minimo = 50` caracteres. O valor padrão de 200 caracteres descartava parágrafos factuais relevantes dos artigos da Briosa e do Jabaquara.
- **Decisão 3 (Indexação Bruta):** Manutenção da tokenização por separação em espaços em branco sem remoção imediata de pontuação, registrando as distorções para embasar experimentalmente as intervenções da Aula 03.

## 7. Diário de Bordo / Histórico das Aulas
- **2026-10-02 (Aula 01 Parte D - Fundação do Projeto):** Sessão de fundação realizada pelo grupo APPA (Arthur Galvão, Pedro Henrique, Ailana). Extração de 141 parágrafos da Wikipédia em português via API oficial, geração dos artefatos `docs.rds` e `origem.rds`, definição do arquivo de configuração `config.R` com `minimo = 50` e `grupo = 'APPA'`, indexação matricial com 2.517 termos únicos e validação de buscas booleanas diretas. Criação da presente Ficha de Projeto.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-02 11:34 · R version 4.6.1 (2026-06-24 ucrt) · motor01 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `busca_ausente` | character | 0 |  |
| `busca_pele` | character | 18 | d2, d13, d14, d16, d35, d36, ... |
| `busca_santos` | character | 90 | d1, d2, d3, d4, d5, d6, ... |
| `cfg$minimo` | numeric | 1 | 50 |
| `cfg$grupo` | character | 1 | APPA |
| `consolidado_parteD_conteudo` | character | 18 | # Consolidado — PI III — Au..., *guia versao 4 · tutora: An..., **Grupo:** APPA (Arthur Gal..., , ## 1. O que foi passado, - M11 — Escolha e delimitac..., ... |
| `consolidado_teoria_conteudo` | character | 39 | # Consolidado — PI III — Au..., *guia versao 4 · tutora: An..., **Grupo:** APPA (Arthur Gal..., , ## 1. O que foi passado, - M1 — Diferenca entre RI e..., ... |
| `df_teoria` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `docs` | character, nomeado | 141 | d1 Santos Futebol Clube , mais..., d2 O Santos tornou-se no futeb..., d3 Ao longo de sua história, o..., d4 O Santos foi eleito pela FI..., d5 O Santos Futebol Clube foi ..., d6 As cores iniciais do Santos..., ... |
| `docs_teoria` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `ficha_conteudo` | character | 65 | # Ficha do Projeto — Motor ..., *criada na Aula 01 (Parte D..., , ## 1. Identificação do Proj..., - **Nome do Grupo:** APPA, - **Integrantes:** Arthur G..., ... |
| `freq_real` | table, nomeado | 3073 | - 1, -sp, 1, " 6, ", 1, ". 1, "a 2, ... |
| `freq_teoria` | table, nomeado | 45 | a 5, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `grep_res` | integer | 2 | 1, 4 |
| `idf_teoria` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `motor_res` | character | 0 |  |
| `MOTOR_VERSAO` | character | 1 | motor01 v1 2026-10-01 |
| `N_real` | integer | 1 | 141 |
| `N_teoria` | integer | 1 | 8 |
| `origem` | character, nomeado | 141 | d1 Santos FC, d2 Santos FC, d3 Santos FC, d4 Santos FC, d5 Santos FC, d6 Santos FC, ... |
| `res_and` | character | 1 | d5 |
| `res_modelo` | character | 2 | d2, d3 |
| `stats_tam` | numeric, nomeado | 3 | min 9, max 331, mean 86 |
| `tam_real` | integer, nomeado | 141 | d1 118, d2 108, d3 151, d4 114, d5 95, d6 43, ... |
| `tdm_real` | matrix | 3073 × 141 | linhas: -, -sp,, ", ... \| colunas: d1, d2, d3, d4, ... |
| `tdm_teoria` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `tfidf_teoria` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `tokens_real$d1` | character | 118 | santos, futebol, clube, ,, mais, conhecido, ... |
| `tokens_real$d2` | character | 108 | o, santos, tornou-se, no, futebol, um, ... |
| `tokens_real$d3` | character | 151 | ao, longo, de, sua, história,, o, ... |
| `tokens_real$d4` | character | 114 | o, santos, foi, eleito, pela, fifa, ... |
| `tokens_real$d5` | character | 95 | o, santos, futebol, clube, foi, fundado, ... |
| `tokens_real$d6` | character | 43 | as, cores, iniciais, do, santos, fc, ... |
| `tokens_real$d7` | character | 158 | a, primeira, apresentação, do, time, considerada, ... |
| `tokens_real$d8` | character | 110 | no, início, de, 1913,, o, santos, ... |
| `tokens_real$d9` | character | 73 | em, 1915,, o, santos, voltou, a, ... |
| `tokens_real$d10` | character | 63 | o, santos, foi, vice-campeão, nas, edições, ... |
| `tokens_real$d11` | character | 70 | o, primeiro, título, paulista, veio, em, ... |
| `tokens_real$d12` | character | 58 | após, 20, anos, do, primeiro, título, ... |
| `tokens_real$d13` | character | 61 | no, ano, seguinte,, chegaria, ao, clube, ... |
| `tokens_real$d14` | character | 39 | ao, lado, de, pepe, ,, coutinho, ... |
| `tokens_real$d15` | character | 67 | ainda, nessa, década,, no, ano, de, ... |
| `tokens_real$d16` | character | 59 | após, pelé, sair, do, santos, em, ... |
| `tokens_real$d17` | character | 107 | o, santos, chegaria, a, final, do, ... |
| `tokens_real$d18` | character | 84 | em, 2002,, ano, em, que, o, ... |
| `tokens_real$d19` | character | 36 | em, 2004,, ainda, com, os, ídolos, ... |
| `tokens_real$d20` | character | 80 | nos, anos, de, 2006, e, 2007, ... |
| `tokens_real$d21` | character | 89 | em, 2009,, começou, aparecer, a, geração, ... |
| `tokens_real$d22` | character | 185 | depois, de, 48, anos,, o, santos, ... |
| `tokens_real$d23` | character | 99 | após, uma, campanha, irregular, no, campeonato, ... |
| `tokens_real$d24` | character | 103 | antes, de, ter, seu, campo,, o, ... |
| `tokens_real$d25` | character | 82 | a, construção, do, estádio, urbano, caldeira,, ... |
| `tokens_real$d26` | character | 61 | o, primeiro, sistema, de, iluminação, foi, ... |
| `tokens_real$d27` | character | 29 | em, 1933,, com, a, morte, de, ... |
| `tokens_real$d28` | character | 82 | o, recorde, de, público, no, estádio, ... |
| `tokens_real$d29` | character | 118 | logo, após, o, término, do, campeonato, ... |
| `tokens_real$d30` | character | 53 | no, dia, 27, de, janeiro, de, ... |
| `tokens_real$d31` | character | 58 | na, copa, do, mundo, de, 2014, ... |
| `tokens_real$d32` | character | 60 | o, santos, realizou, reformas, na, vila, ... |
| `tokens_real$d33` | character | 96 | no, dia, 8, de, outubro, de, ... |
| `tokens_real$d34` | character | 129 | em, 17, de, novembro, de, 2003,, ... |
| `tokens_real$d35` | character | 40 | no, memorial, existem, alguns, espaços, únicos,, ... |
| `tokens_real$d36` | character | 129 | o, centro, de, treinamento, rei, pelé, ... |
| `tokens_real$d37` | character | 112 | no, complexo, com, cerca, de, 40, ... |
| `tokens_real$d38` | character | 20 | o, ct, rei, pelé, foi, o, ... |
| `tokens_real$d39` | character | 34 | no, complexo, do, centro, de, treinamento, ... |
| `tokens_real$d40` | character | 59 | o, santos, futebol, clube, sempre, teve, ... |
| `tokens_real$d41` | character | 53 | localizado, na, av., martins, fontes,, n°, ... |
| `tokens_real$d42` | character | 41 | para, personalizar, a, homenagem, feita, aos, ... |
| `tokens_real$d43` | character | 44 | em, outubro, de, 2016,, como, parte, ... |
| `tokens_real$d44` | character | 83 | a, chácara, nicolau, moran, foi, o, ... |
| `tokens_real$d45` | character | 33 | no, início, da, década, de, 90, ... |
| `tokens_real$d46` | character | 104 | em, um, relatório, publicado, em, 2017, ... |
| `tokens_real$d47` | character | 311 | a, primeira, camisa, seguia, o, padrão, ... |
| `tokens_real$d48` | character | 168 | em, 1963,, o, santos, resolveu, inovar, ... |
| `tokens_real$d49` | character | 221 | em, 2008,, o, santos, lançou, um, ... |
| `tokens_real$d50` | character | 135 | as, cores, iniciais, do, santos, eram, ... |
| `tokens_real$d51` | character | 116 | em, 1915,, o, clube, adotou, o, ... |
| `tokens_real$d52` | character | 142 | em, 1942,, o, santos, chegou, a, ... |
| `tokens_real$d53` | character | 147 | com, base, na, frase:, “o, branco, ... |
| `tokens_real$d54` | character | 331 | de, acordo, com, o, estatuto, social, ... |
| `tokens_real$d55` | character | 66 | há, uma, grande, controvérsia, quanto, ao, ... |
| `tokens_real$d56` | character | 70 | a, revista, placar, lançou, dois, álbuns, ... |
| `tokens_real$d57` | character | 101 | o, santos, futebol, clube, possui, uma, ... |
| `tokens_real$d58` | character | 115 | o, santos, é, o, clube, brasileiro, ... |
| `tokens_real$d59` | character | 89 | em, relação, à, popularidade, dentro, do, ... |
| `tokens_real$d60` | character | 56 | em, pesquisa, realizada, pela, pluri, consultoria, ... |
| `tokens_real$d61` | character | 186 | em, outra, pesquisa, feita, pela, stochos, ... |
| `tokens_real$d62` | character | 107 | além, de, são, paulo, ,, o, ... |
| `tokens_real$d63` | character | 82 | uma, curiosidade, importante, sobre, a, presença, ... |
| `tokens_real$d64` | character | 91 | o, santos, teve, a, segunda, maior, ... |
| `tokens_real$d65` | character | 51 | em, relação, a, sócios-torcedores,, o, santos, ... |
| `tokens_real$d66` | character | 9 | atuais, torcidas, legalizadas, pela, federação, paulista, ... |
| `tokens_real$d67` | character | 88 | o, santos, mesmo, não, sendo, um, ... |
| `tokens_real$d68` | character | 146 | o, clássico, alvinegro, é, o, confronto, ... |
| `tokens_real$d69` | character | 86 | o, fato, mais, marcante, desta, rivalidade, ... |
| `tokens_real$d70` | character | 150 | clássico, da, saudade, é, no, futebol, ... |
| `tokens_real$d71` | character | 50 | os, dois, clubes, já, se, enfrentaram, ... |
| `tokens_real$d72` | character | 135 | o, clássico, com, o, são, paulo, ... |
| `tokens_real$d73` | character | 128 | em, jogos, finais, de, campeonato,, os, ... |
| `tokens_real$d74` | character | 215 | a, rivalidade, contra, os, argentinos, começou, ... |
| `tokens_real$d75` | character | 219 | a, rivalidade, contra, os, "aurinegros", teve, ... |
| `tokens_real$d76` | character | 38 | os, dois, clubes, voltariam, a, decidir, ... |
| `tokens_real$d77` | character | 62 | o, peñarol, é, o, time, estrangeiro, ... |
| `tokens_real$d78` | character | 108 | outro, time, estrangeiro, a, qual, o, ... |
| `tokens_real$d79` | character | 137 | exatamente, quarenta, anos, depois, os, dois, ... |
| `tokens_real$d80` | character | 44 | no, total,, os, dois, times, realizaram, ... |
| `tokens_real$d81` | character | 116 | o, santos, teve, como, primeiro, treinador, ... |
| `tokens_real$d82` | character | 172 | luís, alonso, pérez, ,, o, lula,, ... |
| `tokens_real$d83` | character | 13 | abaixo, os, 10, treinadores, com, mais, ... |
| `tokens_real$d84` | character | 168 | o, santos, sempre, foi, ao, longo, ... |
| `tokens_real$d85` | character | 181 | as, participações, dos, jogadores, do, santos, ... |
| `tokens_real$d86` | character | 178 | em, 1962, ,, no, chile, ,, ... |
| `tokens_real$d87` | character | 52 | na, copa, do, mundo, de, 1966, ... |
| `tokens_real$d88` | character | 100 | em, 1970, ,, no, méxico, ,, ... |
| `tokens_real$d89` | character | 37 | em, 1974, ,, na, alemanha, ,, ... |
| `tokens_real$d90` | character | 42 | em, 2002, ,, o, alvinegro, cedeu, ... |
| `tokens_real$d91` | character | 86 | na, copa, do, mundo, de, 2010, ... |
| `tokens_real$d92` | character | 66 | em, 2006, ,, na, alemanha, ,, ... |
| `tokens_real$d93` | character | 53 | na, copa, do, mundo, de, 2014, ... |
| `tokens_real$d94` | character | 97 | o, santos, b, ,, também, conhecido, ... |
| `tokens_real$d95` | character | 60 | conhecidas, como, as, sereias, da, vila, ... |
| `tokens_real$d96` | character | 97 | para, disputar, o, campeonato, paulista, de, ... |
| `tokens_real$d97` | character | 48 | de, 2009, a, 2012,, o, santos, ... |
| `tokens_real$d98` | character | 83 | o, santos, chegou, a, encerrar, as, ... |
| `tokens_real$d99` | character | 15 | no, dia, 20, de, julho, de, ... |
| `tokens_real$d100` | character | 70 | em, 2011,, com, a, parceria, da, ... |
| `tokens_real$d101` | character | 53 | em, apenas, 1, ano,, o, time, ... |
| `tokens_real$d102` | character | 31 | depois, de, dois, títulos, e, também, ... |
| `tokens_real$d103` | character | 48 | o, voleibol, tanto, no, masculino, como, ... |
| `tokens_real$d104` | character | 85 | em, 1968,, o, ano, do, auge,, ... |
| `tokens_real$d105` | character | 76 | no, feminino,, destaque, para, os, 7, ... |
| `tokens_real$d106` | character | 73 | em, 14, de, abril, de, 2007,, ... |
| `tokens_real$d107` | character | 74 | uma, citação, curiosa, que, o, santos, ... |
| `tokens_real$d108` | character | 98 | a, associação, atlética, portuguesa, ,, mais, ... |
| `tokens_real$d109` | character | 58 | a, mascote, da, portuguesa, santista, é, ... |
| `tokens_real$d110` | character | 61 | em, novembro, de, 1914, ,, "canteiros", ... |
| `tokens_real$d111` | character | 66 | em, 19, de, novembro, de, 1917, ... |
| `tokens_real$d112` | character | 21 | o, seu, estádio,, ulrico, mursa, ,, ... |
| `tokens_real$d113` | character | 103 | a, portuguesa, santista, foi, a, primeira, ... |
| `tokens_real$d114` | character | 50 | a, portuguesa, santista,, é, uma, das, ... |
| `tokens_real$d115` | character | 47 | o, jogo, mais, celebrado, da, portuguesa, ... |
| `tokens_real$d116` | character | 46 | a, portuguesa, é, a, detentora, da, ... |
| `tokens_real$d117` | character | 58 | um, fato, curioso, é, que, a, ... |
| `tokens_real$d118` | character | 52 | em, dois, períodos,, de, 1930, a, ... |
| `tokens_real$d119` | character | 75 | a, melhor, posição, que, a, portuguesa, ... |
| `tokens_real$d120` | character | 64 | no, ano, seguinte,, credenciado, pela, colocação, ... |
| `tokens_real$d121` | character | 13 | em, 2005,, disputou, a, série, c, ... |
| `tokens_real$d122` | character | 18 | em, 2006,, disputou, até, então,, o, ... |
| `tokens_real$d123` | character | 52 | em, 2009,, foi, rebaixada, para, a, ... |
| `tokens_real$d124` | character | 108 | em, 2016,, depois, de, 6, anos,, ... |
| `tokens_real$d125` | character | 23 | em, 2017,, completou, seu, centenário, ., ... |
| `tokens_real$d126` | character | 30 | na, disputa, da, série, a3, de, ... |
| `tokens_real$d127` | character | 56 | em, 2025,, foi, rebaixada, para, a, ... |
| `tokens_real$d128` | character | 118 | em, 2026,, a, briosa, conseguiu, o, ... |
| `tokens_real$d129` | character | 29 | o, estádio, ulrico, mursa, foi, fundado, ... |
| `tokens_real$d130` | character | 43 | fica, situado, próximo, ao, centro, de, ... |
| `tokens_real$d131` | character | 35 | jabaquara, atlético, clube, é, uma, agremiação, ... |
| `tokens_real$d132` | character | 34 | a, agremiação,, anteriormente, chamada, hespanha, fbc, ... |
| `tokens_real$d133` | character | 99 | um, grupo, de, jornaleiros, espanhóis, ,, ... |
| `tokens_real$d134` | character | 53 | a, sua, primeira, partida, oficial, ocorreu, ... |
| `tokens_real$d135` | character | 71 | nos, anos, de, 1918, a, 1920, ... |
| `tokens_real$d136` | character | 74 | estreou, em, competições, profissionais, no, ano, ... |
| `tokens_real$d137` | character | 119 | em, 1944, o, time, atingiu, o, ... |
| `tokens_real$d138` | character | 75 | no, entanto,, em, 1945, o, clube, ... |
| `tokens_real$d139` | character | 85 | assim, correram, os, anos, até, que, ... |
| `tokens_real$d140` | character | 71 | em, 1960, ,, se, estabeleceu, em, ... |
| `tokens_real$d141` | character | 71 | em, luta, pela, sobrevivência,, este, histórico, ... |
| `tokens_teoria$d1` | character | 7 | recuperacao, de, informacao, ordena, documentos, por, ... |
| `tokens_teoria$d2` | character | 9 | o, modelo, de, espaco, vetorial, representa, ... |
| `tokens_teoria$d3` | character | 9 | bm25, e, um, modelo, probabilistico, de, ... |
| `tokens_teoria$d4` | character | 6 | aprendizado, estatistico, fundamenta, a, recuperacao, moderna |
| `tokens_teoria$d5` | character | 9 | o, indice, invertido, acelera, a, busca, ... |
| `tokens_teoria$d6` | character | 8 | embeddings, capturam, a, semantica, de, palavras, ... |
| `tokens_teoria$d7` | character | 9 | a, avaliacao, mede, a, relevancia, dos, ... |
| `tokens_teoria$d8` | character | 7 | ciencia, de, dados, combina, estatistica, e, ... |
| `top10_freq` | table, nomeado | 10 | o 604, de 567, a 412, , 301, e 292, em 278, ... |
| `url_motor` | character | 1 | https://raw.githubuserconte... |
| `vocab_real` | character | 3073 | -, -sp,, ", ",, "., "a, ... |
| `vocab_teoria` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |

### Funções definidas

`anexar_estado`, `busca_booleana`, `estado`, `tokenizar`
<!-- estado-R:fim -->

