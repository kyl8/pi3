# Julgamento `claude_leitura` (2º juiz LLM) — pool v2

*2026-11-06. Arquivo de apoio. **Não substitui o julgamento humano** (Aula 05: LLM só entra como segundo juiz, na Parte 2, e nunca misturado aos qrels humanos).*

## O que foi feito

1. `05h-gerar-pool-v2.R` gerou o pool com o motor atual (BM25, cosseno, LSA k=20, híbrido RRF; top-10 de cada; união embaralhada). 101 pares; 56 não estavam no pool antigo (66 pares).
2. `estrutura/corpus/banco-de-dados/guia_julgamento.md` foi escrito **antes** do julgamento, com 9 casos de fronteira decididos de antemão.
3. Cada par do pool foi lido e julgado contra a **necessidade em prosa** (não contra as palavras da consulta), sem abrir o arquivo de origem (`...-origem-AUDITORIA.csv`). Método: `leitura_cega_guia_v1`.
4. Busca complementar: li o corpus inteiro (141 parágrafos) e julguei 51 parágrafos relevantes que o pool não trazia (método `leitura_manual_fora_do_pool`). Sem isso, o MAP seria calculado com R subestimado (o pooling perde relevantes que nenhum modelo recupera).
5. Resultado: `estrutura/codigos/05-julgamento/csv/2026-11-06-appa-05-qrels-claude.csv` (152 pares, `juiz = claude_leitura`). Colunas `timestamp` preenchida e `segundos` vazia (não há cronômetro; não inventei).

Nada foi escrito em `julgamentos-humanos/juiz_01..03.csv`, em `qrels_assistidos.csv` ou em `config.R`.

## Graus por consulta (limiar ≥ 2)

| consulta | conjunto | grau 2 | grau 1 | R (≥2) |
|---|---|---|---|---|
| q01 história do Santos | dev | d1, d5, d7, d8 | 23 | 4 |
| q02 títulos do Santos | teste | 15 | 11 | 15 |
| q03 estádio/sede da Portuguesa | dev | d112, d129, d130 | 6 | 3 |
| q04 história/identidade do Jabaquara | teste | 11 | 3 | 11 |
| q05 rivalidades/confrontos do Santos | dev | 14 | 9 | 14 |
| q06 estádio do Jabaquara | dev | d135, d140 | 2 | 2 |

## Dúvidas e a decisão tomada

| par | decisão | motivo |
|---|---|---|
| q01 × d6, d47, d50, d51, d53 (cores, escudo, bandeira) | 1 | tratam da origem do clube, mas só do visual; a fundação em si não está ali |
| q01 × d10, d11, d17, d19, d21, d22, d23 (títulos, rebaixamento) | 1 | história do clube, não formação |
| q01 × d7 (primeiro jogo, 1912) | 2 | descreve o início do time; quem pediu "formação" fecharia a aba |
| q02 × d103, d104, d105 (vôlei do Santos) | 1 | títulos do clube em outra modalidade; a necessidade é sobre o Santos **Futebol** Clube |
| q02 × d99 (Brasileiro Feminino 2017) | 2 | título de futebol do clube |
| q02 × d9 (2º título santista, 1915) | 1 | cita o título de passagem, jogando com o nome União FC |
| q03 × d124, d127 (jogos em Ulrico Mursa) | 1 | citam o estádio como cenário, sem descrevê-lo (caso 6 do guia) |
| q05 × d76 | 1 | final de Libertadores 2011, mas o parágrafo não nomeia o adversário |
| q05 × d139 (Jabaquara 1957 vence o Santos) | 1 | confronto isolado, não rivalidade |
| q05 × d107 (hino do Olympiacos) | 1 | tem "Santos" mas não é confronto (o codex deu 2) |
| q06 × d131, d138 | 1 | cidade-sede / campo de treino em São Vicente, sem descrever estádio |
| q06 × d140 | 2 | descreve o campo do clube (8 mil pessoas), sem usar a palavra "estádio" |
| q06 × d135 | 2 | descreve o Estádio Antonio Alonso, no Macuco, construído em 1924 |
| q01 × d70 (Clássico da Saudade) | 0 | rivalidade, não história do clube (o codex deu 1) |

**q06 deixa de ser vazia**: d135 e d140 respondem. O qrels antigo estava errado (regex copiado da q03). O grupo precisa confirmar.

## Concordância com o `codex_assistido`

47 pares em comum, 3 divergências (`estrutura/codigos/resultados/2026-11-06-appa-05i-DiscordanciasClaudeCodex.csv`).

| escala | po | pe | kappa |
|---|---|---|---|
| 3 níveis (0/1/2) | 0,936 | 0,338 | **0,904** |
| binária (≥2) | 0,979 | 0,558 | **0,952** |

**Não leia isso como validação.** São dois LLMs, e eu tinha visto o qrels do codex durante a auditoria, então o julgamento não foi independente dele. Kappa alto entre juízes LLM diz que os dois leem o guia do mesmo jeito, não que o gabarito está certo. O kappa que vale para a nota é o **humano × humano**, que ainda não existe.

## Métricas com estes qrels (`05i-avaliar-qrels-claude.R`)

Arquivo: `estrutura/codigos/resultados/2026-11-06-appa-05i-MetricasClaudeLeitura.csv`. Não julgados no top-5 e no top-10: **0** em todos os modelos (o pool v2 cobre tudo, ao contrário do antigo).

| modelo | P@3 | MAP | MRR | nDCG graduado |
|---|---|---|---|---|
| bm25 | 0,333 | 0,301 | 0,628 | 0,752 |
| cosseno | 0,389 | 0,308 | 0,632 | 0,751 |
| LSA k=20 | 0,444 | 0,336 | 0,625 | 0,712 |
| **híbrido** | **0,500** | **0,363** | **0,685** | 0,753 |

| conjunto | bm25 MAP | híbrido MAP |
|---|---|---|
| dev (q01,q03,q05,q06) | 0,238 | 0,313 |
| teste (q02,q04) | 0,429 | 0,463 |

Com estes qrels o híbrido **não piora no teste** (a auditoria dizia que piorava; isso dependia do qrels antigo, que tinha q06 vazia e pool defasado). Mas a diferença é pequena, vem de 6 consultas e de um juiz LLM. **Não mude o modelo padrão com base nisto.** Decidir com os qrels humanos.
