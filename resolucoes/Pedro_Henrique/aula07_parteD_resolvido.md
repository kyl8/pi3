# Aula 07 — Parte D resolvida no APPA
**Pedro Henrique · APPA · Guia versão 2 · 25/10/2026 · apoio: Codex.**

## Ficha em três linhas
APPA estuda um buscador sobre Santos FC, Portuguesa Santista e Jabaquara, voltado à memória do futebol regional.
O corpus congelado tem $141$ parágrafos e as consultas `q01`–`q06`; `q02` e `q04` estão no teste retrospectivo.
A Aula 06 deixou `prf_k=0`; feedback foi medido e o pseudo-feedback piorou o desenvolvimento; votos humanos seguem pendentes.

## M7 — LSA no corpus e leitura do top-5
A matriz preparada tem $1902\times141$ posições. Com $k=20$, a energia retida é
$0,436549$. A seleção usa o CSV congelado e a mesma limpeza, stopwords e stemming das consultas.
Não recoletei textos nem troquei identificadores após os julgamentos.

Para `q01` (“historia santos futebol clube”), os dois top-5 compartilham **três documentos**:
`d4`, `d95` e `d2`. O BM25 traz só `d139` e `d109`; o LSA, só `d55` e `d15`.

**Só LSA, `d55`:** o trecho trata dos hinos do Santos e da marchinha “Leão do Mar”, associada
ao título paulista de 1955. É um contexto histórico do clube, aproximado pelos termos
`sant`, `futebol` e `club`, mas não responde diretamente à sua fundação. Seu grau assistido existente é $1$.
Não é um exemplo de recuperação sem nenhuma palavra em comum: ele compartilha três termos preparados.

**Só BM25, `d139`:** descreve uma vitória histórica do Jabaquara sobre o Santos e os rebaixamentos
do Jabaquara. Contém os quatro termos preparados `histor`, `sant`, `futebol` e `club`,
por isso o encaixe lexical é forte mesmo que o foco seja o outro clube. O par está **não julgado**
nessa consulta; não o converti em um voto humano nem alterei o qrels para melhorar o resultado.

**Checkpoint 7:** três em comum; os documentos exclusivos e a contagem de termos acima
explicam por que comparar somente escores esconderia o contexto e o ruído.

## M8 — Candidatos no desenvolvimento e teste após a escolha
Mantive os candidatos $k\in\{2,10,20,50,80,141\}$ que já existiam na implementação.
BM25, LSA e RRF são medidos apenas no desenvolvimento durante essa varredura.
São quatro consultas de desenvolvimento cadastradas; `q06` não tem relevante com grau
$\geq2$ na pool e fica fora do MAP. Restam **três consultas válidas** para escolher.

O híbrido com $k=20$ venceu no desenvolvimento: MAP BM25
$0,594298$, LSA $0,583712$ e híbrido
$0,653319$. Ele perde para BM25 em **0 de três** consultas válidas
de desenvolvimento; empata em `q03`. O LSA puro perde em `q01` e `q05`.

| Consulta | Conjunto | AP BM25 | AP LSA | AP híbrido |
|---|---|---:|---:|---:|
| q01 | dev | $0,122378$ | $0,094298$ | $0,146465$ |
| q03 | dev | $1,000000$ | $1,000000$ | $1,000000$ |
| q05 | dev | $0,660516$ | $0,656838$ | $0,813492$ |
| q02 | teste_retrospectivo | $0,091023$ | — | $0,095635$ |
| q04 | teste_retrospectivo | $0,686190$ | — | $0,388376$ |

Os traços do LSA no teste são intencionais: a execução atual só abre o teste para BM25
e o modelo escolhido na dimensão congelada. A versão anterior já havia avaliado essas
consultas; portanto este continua sendo **teste retrospectivo**, sem alegação de um teste novo intocado.
Não escolhi outro $k$ depois de relatar o teste.

### Tarefa do grupo: um ganho e uma perda, com leitura dos textos
**Ganho, `q05` no desenvolvimento:** AP BM25
$0,660516\to 0,813492$ no híbrido.
Na consulta sobre rivalidades do Santos, `d75`, que relata a rivalidade e a final contra o
Peñarol, sobe da quinta para a segunda posição. O trecho responde ao tema dos confrontos.
`d48`, sobre mudanças do uniforme e uma menção ao Corinthians, oferece contexto mais indireto;
a fusão prioriza `d75`, embora ainda mantenha ruído no topo.

**Perda, `q04` no teste retrospectivo:** AP BM25
$0,686190\to 0,388376$ no híbrido.
O BM25 coloca `d136` e `d141`, sobre a trajetória e os títulos do Jabaquara, no top-5.
O híbrido os substitui por `d108` e `d114`, que tratam da Portuguesa Santista e da fundação
da federação, com referências ao antigo Hespanha. A associação histórica aproxima clubes,
mas dilui a identidade do Jabaquara que a necessidade pede. Esses dois já têm grau assistido
$1$, enquanto `d136` e `d141` têm grau $2$.
Essa leitura explica a perda; não foi usada para reajustar a configuração.

**Checkpoint 8:** escolhi o híbrido com $k=20$ pelo MAP de desenvolvimento; nenhuma perda
do híbrido nas três consultas válidas de desenvolvimento, mas o teste piora e a pool é pequena e parcial.

## M9 — Decisão e integração
Mantenho `modelo="hibrido"`, `lsa_k=20` e `rrf_c=60`, com `prf_k=0`.
O MAP de desenvolvimento sobe de $0,594298$ para
$0,653319$; no teste retrospectivo cai de
$0,388607$ para $0,242005$.
Os dois caminhos de `config.R` concordam com a ficha. A função `ranking_motor` aplica
essa escolha; `ranking_modelo` rejeita nomes inválidos e não calcula SVD quando o modelo é BM25.

**Checkpoint 9:** a frase acima, os parâmetros e os números coincidem com os arquivos gerados.
A decisão foi preparada com apoio de Codex, sem inventar uma reunião ou concordância dos colegas.

## Arquivos e fechamento
- [Consolidado do grupo](../../consolidados/aula07_parteD_consolidado.md)
- [Código executável](../../estrutura/codigo/aula07.R) e [notebook](../../estrutura/codigo/aula07.ipynb)
- [Comparação do top-5](../../estrutura/resultados/2026-10-25-appa-07-ComparacaoTop5.csv)
- [Termos compartilhados](../../estrutura/resultados/2026-10-25-appa-07-TermosTop5.csv)
- [Rankings com textos](../../estrutura/resultados/2026-10-25-appa-07-LsaRrfTop5.csv)
- [Placar de desenvolvimento e teste](../../estrutura/resultados/2026-10-25-appa-07-LsaPlacarDevTeste.csv)
- [Top-5 do motor configurado](../../estrutura/resultados/2026-10-25-appa-07-RankingMotorTop5.csv)
