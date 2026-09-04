# Consolidado - Entrega 1: Motores de Busca Lexicais e Probabilisticos

Este documento consolida a primeira entrega do projeto de Recuperacao de Informacao, integrando os modelos desenvolvidos pelo grupo **APPA** (Arthur, Pedro, Pedro, Ailana) para a disciplina de Projeto Integrador III.

---

## 1. Identificacao do Projeto e Grupo

* **Grupo:** APPA
* **Integrantes:**
  * Arthur Galvao
  * Pedro Henrique
  * Ailana
* **Disciplina:** Projeto Integrador III (Ciencia de Dados - FATEC)
* **Tema:** Arquitetura de Motores de Busca e Modelos de Recuperacao Textual

---

## 2. Artefatos e Codigos Desenvolvidos

Os codigos foram padronizados dentro da pasta `estrutura/código/` conforme as datas de evolucao dos modelos:

1. **[2026-08-20-appa-MotorDeBusca.r](estrutura/código/2026-08-20-appa-MotorDeBusca.r):**
   * Primeira versao do motor baseada em correspondencia exata de frequencia de termos e extracao de sentencas dos artigos da Wikipedia.
2. **[2026-08-25-appa-MotorBuscaTfIdf.r](estrutura/código/2026-08-25-appa-MotorBuscaTfIdf.r):**
   * Motor de espaco vetorial com ponderacao linear TF-IDF e calculo de similaridade via Cosseno. Suporte a consultas booleanas (AND, OR, NOT).
3. **[2026-09-04-appa-MotorBuscaBM25.r](estrutura/código/2026-09-04-appa-MotorBuscaBM25.r):**
   * Motor probabilistico baseado no algoritmo BM25 (Best Matching 25) com aproximacao 2-Poisson, saturacao de termos, penalizacao de comprimento de documento e modo comparativo direto de ranqueamento.

---

## 3. Resumo Tecnico dos Modelos

### Modelo Vetorial (TF-IDF + Cosseno)
* Transforma documentos e consultas em vetores de pesos calculados por:
  $$\text{TF}(t, d) \times \log\left(\frac{N}{\text{df}_t}\right)$$
* Avalia a proximidade angular atraves da Similaridade do Cosseno.

### Modelo Probabilistico (BM25)
* Introduz o IDF probabilistico de Robertson-Sparck Jones com suavizacao:
  $$\text{IDF}(t) = \log\left(\frac{N - \text{df}_t + 0.5}{\text{df}_t + 0.5} + 1\right)$$
* Controla a saturacao da frequencia atraves de $k_1 = 1.2$ e a penalizacao do tamanho do documento via $b = 0.75$:
  $$\text{BM25}(q, d) = \sum_{t \in q} \text{IDF}(t) \cdot \frac{f_{t,d} \cdot (k_1 + 1)}{f_{t,d} + k_1 \left(1 - b + b \cdot \frac{|d|}{\text{avgdl}}\right)}$$

---

## 4. Instrucoes de Reproducao

Para executar o motor mais recente (BM25), utilize no interpretador R:

```R
source("estrutura/código/2026-09-04-appa-MotorBuscaBM25.r")
```
