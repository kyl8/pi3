# Guia de julgamento — corpus APPA (clubes da Baixada Santista)

*Versão 1, 2026-11-06. Escrito antes do julgamento v2, a partir da leitura do corpus (141 parágrafos da Wikipédia sobre Santos FC, Portuguesa Santista e Jabaquara). Os casos de fronteira abaixo foram decididos **antes** de ver o pool; os ids citados vêm do corpus congelado.*

**Regra de ouro:** julga-se contra a **necessidade em prosa** (`necessidades.csv`, coluna `necessidade`), nunca contra as palavras da consulta. Palavra em comum não é relevância. O artigo de origem do parágrafo (Santos, Portuguesa, Jabaquara) também não decide nada: conta o que o parágrafo diz.

## Escala

| grau | frase operacional para este corpus |
|---|---|
| **2** | O parágrafo, sozinho, entrega a informação pedida: um fato, nome, data, lista ou descrição que responde à necessidade, mesmo que venha junto de outros assuntos. |
| **1** | O parágrafo trata do assunto da necessidade ou do mesmo clube e dá contexto útil, mas **não** entrega a informação pedida (fala em volta, só toca de passagem, ou responde outra pergunta parecida). |
| **0** | Outro clube, outro assunto, ou menção sem relação com a necessidade, inclusive quando repete palavras da consulta (homônimo, bairro, nome de pessoa). |

## Casos de fronteira decididos

1. **Escopo vale pelo conteúdo, não pelo artigo.** `d115` (artigo da Portuguesa) diz que o jogo mais celebrado da Portuguesa é contra o Santos, o "Clássico das Praias". Para **q05** (rivalidades/confrontos do Santos): **2**, pois nomeia um confronto do Santos. Para **q03** (estádio da Portuguesa): **0**.
2. **Parágrafo-resumo que cita a resposta no meio de outras coisas.** `d1` define o Santos e menciona fundação, cores, estádio e rivais. Para **q01** (história e formação): **2**, porque traz a data de fundação e a decisão sobre as cores. Para **q05**: **2**, pois lista os três rivais e os nomes dos clássicos. Para **q02** (títulos): **0**, pois não cita nenhum título.
3. **Elogio genérico sem o fato pedido.** `d2` diz que o Santos é um dos clubes mais bem-sucedidos e ficou famoso pelos títulos nos anos 60, mas não nomeia nenhum. Para **q02**: **1**. `d3`, que lista os títulos, é **2**.
4. **Estádio de outro clube.** `d25`, `d24`, `d28` (Vila Belmiro) para **q03** ou **q06**: **0**. A palavra "estádio" e a cidade de Santos coincidem, mas é o estádio do Santos.
5. **Nome do clube usado como lugar ou como outro clube.** `d110` (artigo da Portuguesa) cita o "bairro do Jabaquara" e o Hespanha FC, atual Jabaquara, só como cenário da fundação da Portuguesa. Para **q04** (história/identidade do Jabaquara): **1**, pois diz que o Hespanha é o atual Jabaquara e que foi visto jogando em 1914, mas o foco é a Portuguesa. Quando o Jabaquara aparece só como adversário ou bairro, **0**.
6. **Informação sobre o campo sem usar a palavra "estádio".** `d140` descreve a compra de um terreno na Caneleira com campo para 8 mil pessoas, CT e quadra. Para **q06** (estádio do Jabaquara): **2**, pois descreve o campo do clube, ainda que sem dar nome ao estádio. Se só disser que "o clube mandou o jogo em X", **1**.
7. **Parágrafo muito curto.** `d112` ("Ulrico Mursa, inaugurado em 1920, primeiro da América Latina com cobertura de concreto") é curto, mas responde q03: **2**. Tamanho não muda o grau.
8. **Informação correta, mas sobre outra pergunta da mesma entidade.** Parágrafo sobre rebaixamento da Portuguesa para **q03**: **0** (nada sobre estádio ou sede). Sobre a cidade-sede ("clube fundado e sediado em Santos") sem endereço ou estádio: **1**.
9. **Duplicata ou quase repetição de outro parágrafo.** Julga-se cada um pelo que diz; duplicatas não são desempatadas.

## Quando em dúvida

Entre 2 e 1: pergunte "quem perguntou isso fecharia a aba com esta resposta?". Se sim, **2**. Entre 1 e 0: "este parágrafo ajuda a entender o assunto ou só repete uma palavra?". Se só repete, **0**. Dúvida não resolvida vai para a lista de dúvidas do consolidado, com a decisão tomada e o motivo.
