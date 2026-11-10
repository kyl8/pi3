# Pendências do grupo (o que NÃO dá para fazer por script)

*2026-11-06. Tudo o que era possível corrigir sem decisão ou trabalho humano já está no patch `correcoes-pi3.patch`. O que sobra está abaixo, em ordem de impacto na nota. Cada item diz o que fazer, por quê e como saber que acabou.*

Referências: auditoria completa em `ERROS-pi3.md`; julgamento do 2º juiz LLM em `consolidados/2026-11-06-appa-JulgamentoClaudeLeitura.md`.

---

## 🔴 1. Julgamento humano (bloqueia o resto)

**Por quê.** A Aula 05 exige que humanos julguem relevância. Hoje o único gabarito é `codex_assistido` (LLM) e agora também `claude_leitura` (LLM). Os três `juiz_0N.csv` continuam **vazios**. Sem isso, o kappa humano não existe e todas as métricas do repo (e a escolha do modelo) se apoiam em juiz LLM.

**Fazer.**
1. Julgar o **pool v2** (`csv/2026-11-06-appa-05-pool-v2.csv`, 101 pares), não o pool antigo. O script `05f-preparar-julgamentos-humanos.R` ainda lê `2026-09-15-appa-05-pool.csv` (linha 9). Trocar por `2026-11-06-appa-05-pool-v2.csv` e rodar **antes** de qualquer um preencher: ele regrava `juiz_01..03.csv` e apaga o que já tiver sido preenchido.
2. Cada pessoa (Arthur, Pedro, Ailana) julga **sozinha, sem ver os graus do codex nem do claude** (`claude_leitura` está em `csv/2026-11-06-appa-05-qrels-claude.csv`; não abram antes de terminar). Usar `estrutura/banco-de-dados/guia_julgamento.md` como guia. Se o grupo discordar do guia, corrijam o guia e registrem a mudança.
3. Rodar `05g-consolidar-julgamentos-humanos.R` e `05a-kappa.R` (corrigido no patch) para obter o **kappa humano × humano** e o gabarito consolidado.
4. Não abrir `...-pool-v2-origem-AUDITORIA.csv` até todos terminarem (ele diz de qual modelo veio cada parágrafo e enviesa).

**Pronto quando:** os 3 CSV têm grau em todos os 101 pares, há kappa par a par no consolidado e a lista de divergências foi discutida e decidida.

**Atenção às minhas respostas.** O `claude_leitura` é uma tentativa de julgar "como humano", mas é um LLM. Servem para (a) comparar depois com os humanos (Parte 2 da Aula 05) e (b) mostrar onde há ambiguidade. Nunca entram no mesmo arquivo que os qrels humanos.

---

## 🔴 2. Completar o pool com busca manual

**Por quê.** O pooling só vê o que os 4 modelos recuperam. Na leitura do corpus achei 51 parágrafos relevantes fora do pool (ex.: q01: d5 e d7, a fundação e o primeiro jogo; q03: d130, o endereço do estádio da Portuguesa; q05: Palmeiras/São Paulo/Boca/Peñarol). Se os humanos julgarem só o pool, o R (total de relevantes) fica subestimado e o MAP infla.

**Fazer.** Cada juiz humano percorre o corpus (141 parágrafos) por consulta e anota relevantes que não estavam no pool. Lista dos meus achados: linhas `leitura_manual_fora_do_pool` do `qrels-claude.csv` (conferir só **depois** de fazer a sua).

**Pronto quando:** o consolidado humano tem uma coluna/método indicando "fora do pool" e o relatório cita quantos foram.

---

## 🔴 3. Escolha do modelo (BM25 × híbrido) com base real

**Situação.** O `config.R` usa híbrido (RRF de BM25 + LSA k=20). A auditoria dizia que ele piorava no teste. Com os qrels `claude_leitura`, ele **melhora** (MAP geral 0,363 contra 0,301 do BM25; teste 0,463 contra 0,429), mas:
- são 6 consultas, só 4 no dev (q06 tem R=2 e q03 tem R=3);
- o juiz é LLM;
- a ordem entre modelos muda de consulta para consulta (q01 e q04: BM25 melhor; q02, q03, q05, q06: LSA ou híbrido melhor).

**Fazer.** Depois do item 1, rodar `05i-avaliar-qrels-claude.R` trocando o arquivo de qrels pelo humano consolidado (a leitura está na linha `cl <- read.csv(...)`). Escolher o modelo pelo MAP **no dev**, olhar o teste uma vez, e registrar na ficha por que ficou com ele. Se a diferença for menor que a variação entre juízes, o texto deve dizer isso. Aumentar para 10 ou mais consultas dev ajudaria bem mais que ajustar k.

**Não alterei `config.R`.**

---

## 🔴 4. Alinhar as três consultas de trabalho e preencher a seção 4 da ficha

**Situação.** Há 3 conjuntos de consultas diferentes (ficha §2, `aula02.R`, ParteD) mais as 6 de avaliação (`necessidades.csv`). A ficha não tem a **seção 4 com os rankings**, e o professor testa justamente "rodo `aula02.R` e os rankings batem com a ficha".

**Fazer.**
1. Decidir quais 3 consultas são as "de trabalho" (sugestão: as que também estão em q01–q06, para o julgamento servir às duas coisas).
2. Escrever as mesmas 3 em ficha, `aula02.R`, ParteD e `necessidades.csv`.
3. Rodar `aula02.R` e colar o top-5 de cada consulta na seção 4 da ficha.
4. Decidir o que fazer com "cores" da Portuguesa (sumiu das consultas, mas está na pergunta canônica).

**Pronto quando:** o ranking impresso por `aula02.R` é idêntico ao da ficha.

---

## 🟠 5. Confirmar q06 (estádio do Jabaquara)

**Situação.** O qrels antigo dizia que q06 não tinha nenhum relevante. Na leitura, d135 (Estádio Antonio Alonso, Macuco, 1924) e d140 (campo de 8 mil pessoas na Caneleira) respondem. Se os humanos concordarem, q06 fica com R=2 (consulta válida, mas frágil). Se discordarem, trocar a consulta por outra com resposta no corpus. Não mantenham consulta com R=0 no dev: AP indefinido não conta e distorce a média.

---

## 🟠 6. Rodar localmente os scripts que não consegui executar

**Situação.** Eu corrigi por leitura e testei só: o pool v2, o kappa, as métricas e o ajuste do nDCG/P@3. Os demais scripts (os que fazem scraping, o `aula07_lsa.R`, `GuiasEstudo.R`, `Atividade05b-ParteD`) **não foram rodados de ponta a ponta** neste ambiente.

**Fazer.** Na raiz do repo, em R, nesta ordem: `aula07_lsa.R` → `05a-kappa.R` → Parte D da 5,5. Se aparecer erro, mande a mensagem. Os CSV de `estrutura/resultados/` de setembro e outubro foram gerados com `k1 = 1,2` e 90 stopwords (script BM25 antigo) ou qrels antigos: regenerar ou marcar como obsoletos (o README de resultados já avisa, mas os arquivos não têm marca).

---

## 🟠 7. Remover ou realocar `entregas/modelo_base/entrega-1-pergunta`

É o modelo de Teoria do Aprendizado Estatístico (variável-alvo e preditores), que não se aplica ao PI III. Não tem target nem preditor num motor de busca. O README já avisa; o certo é mover para o repositório da outra disciplina (se a entrega de TAE estiver pendente, ela precisa de repo próprio). **Decisão do grupo**, por isso não apaguei.

---

## 🟠 8. Git

- **E-mail do Pedro:** `git config --global user.email "127747409+kyl8@users.noreply.github.com"` (senão os commits não contam no perfil).
- **Ailana não tem commits.** Se ela contribuiu (julgamento, texto), os commits devem aparecer no nome dela, ou o diário da ficha deve registrar quem fez o quê. O professor olha o histórico.
- **Histórico:** 7 commits em lote em 25/10 refazendo guias 00–07. Daqui para frente, um commit por sessão prática com mensagem que diga o que mudou.
- **Aplicar o patch:** `git apply --check correcoes-pi3.patch` e depois `git apply correcoes-pi3.patch`. O patch já inclui os arquivos novos (`guia_julgamento.md`, `05h`, `05i`, CSV, consolidado e este arquivo). **Eu não fiz commit nem push** (instrução do projeto): suba pelo seu GitHub.

---

## 🟡 9. Limpeza que precisa de decisão

- **Duas pastas** `estrutura/codigo` e `estrutura/codigos`: escolher uma e redirecionar o `file.copy` do fim do `aula07_lsa.R`.
- **Cópias duplicadas** (`docs.rds`, `origem.rds`, `corpus.csv`, `necessidades.csv` com esquemas diferentes, `qrels_assistidos.csv`): manter uma fonte e gerar as outras, ou apagar.
- **Três versões da Atividade 02** em `consolidados/`: marcar qual vale.
- **Ficha §3 (fonte)** descreve a API `extracts`, mas o código faz scraping de `action=render`. Corrigir um dos dois.
- **Ficha §6/§7:** registrar a decisão de crescer o corpus de 20–60 para 141 parágrafos e acrescentar uma entrada de diário por sessão.
- **Ficha §2:** a ficha declara "Apoio: ChatGPT" e o gabarito é `codex_assistido`; a seção precisa dizer com clareza que o julgamento humano foi feito (depois do item 1) e que o LLM é segundo juiz.

---

## Ordem sugerida

1 → 2 (juntos, mesma sessão) → 3 → 4 → 5 → 6 → 8 → 7 e 9. Os itens 4, 7, 8 e 9 podem ser feitos em paralelo por pessoas diferentes enquanto os humanos julgam.
