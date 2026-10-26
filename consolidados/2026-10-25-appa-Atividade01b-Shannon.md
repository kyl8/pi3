# Aula 01b — Shannon e os pesos dos termos
**APPA · Pedro Henrique · 2026-10-25.**

Para escolher um entre $N$ documentos equiprováveis, começo com $\log_2N$ bits de incerteza.
Se um termo aparece em $df$ deles, a pista fornece $I(t)=-\log_2(df/N)=\log_2(N/df)$ bits.
O IDF com logaritmo natural só muda a escala: $\ln(N/df)=\ln(2)I(t)$.

| termo | df | informacao_bits | idf_natural |
|---|---|---|---|
| busca | 2 | 2 | 1.38629436111989 |
| de | 5 | 0.678071905112638 | 0.470003629245736 |
| modelo | 2 | 2 | 1.38629436111989 |
| recuperacao | 2 | 2 | 1.38629436111989 |

Somei frequências e presenças separadamente: repetir o termo no mesmo documento aumenta TF,
sem aumentar DF. Termo em todo documento tem IDF zero; termo fora do vocabulário não fornece
evidência recuperável para este índice. Somar bits pressupõe pistas independentes: “aprendizado” e
“estatístico” aparecem juntos no corpus didático e a soma conta evidência repetida.

Repeti as contas no corpus APPA de 141 parágrafos. Todas as palavras, frequências, probabilidades,
bits e IDF estão nos [pesos](../estrutura/resultados/guias/aula01b_shannon_termos.csv);
a dependência entre pistas está na [comparação de pares](../estrutura/resultados/guias/aula01b_shannon_pares.csv).
[Código](../estrutura/codigos/2026-10-25-appa-FundamentosShannon.R).
