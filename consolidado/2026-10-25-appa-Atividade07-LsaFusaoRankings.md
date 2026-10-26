# Atividade 07 — LSA e fusão de rankings
**APPA · 2026-10-25 · corpus congelado de 141 documentos.**

Refiz a atividade conforme a atualização do Danilo, aplicando o procedimento ao corpus dos clubes do APPA.
Decomponho $W=U\Sigma V^T$, represento documentos pelas linhas de $V_k\Sigma_k$ e a consulta por $U_k^Tq$.
O RRF soma $1/(c+\mathrm{posição})$, com $c=60$, sem combinar escalas incompatíveis de escores.

## Escolha e avaliação
Explorei $k\in\{2,10,20,50,80,141\}$. A maior MAP de desenvolvimento foi
0,653, com **hibrido e $k=20$**. A configuração foi persistida.

| conjunto | modelo | AP |
|---|---|---|
| dev | bm25 | 0.594297831797832 |
| teste_retrospectivo | bm25 | 0.388606510236945 |
| dev | hibrido | 0.653318903318903 |
| teste_retrospectivo | hibrido | 0.242005494505494 |
| dev | lsa | 0.583711950817214 |
| teste_retrospectivo | lsa | 0.117096383375453 |

O híbrido perde para BM25 no teste retrospectivo, embora tenha sido escolhido no desenvolvimento.
Mantenho a escolha registrada; não reajusto $k$ olhando o teste. Essas consultas já tinham sido usadas
em versões anteriores: a separação é retrospectiva e não demonstra generalização a consultas inéditas.
O gabarito é assistido, identificado e parcial; q06 fica fora do MAP por não ter grau dois na pool.

## Leitura qualitativa e entregas
Os três rankings top-5 de cada necessidade incluem texto e grau no CSV `07-LsaRrfTop5.csv`.
A curva por dimensão, a energia retida, o placar e os AP por consulta permitem verificar onde
o espaço denso ajuda e onde introduz vizinhos que não respondem à pergunta.

- [Código](../estrutura/codigos/aula07_lsa.R)
- [Candidatos no desenvolvimento](../estrutura/resultados/2026-10-25-appa-07-LsaMapPorKDev.csv)
- [Todos os AP](../estrutura/resultados/2026-10-25-appa-07-LsaPorConsultaTodosK.csv)
- [Placar](../estrutura/resultados/2026-10-25-appa-07-LsaPlacarDevTeste.csv)
- [Top-5 com textos](../estrutura/resultados/2026-10-25-appa-07-LsaRrfTop5.csv)
