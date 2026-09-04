# Projeto Integrador III - Recuperacao de Informacao

Este repositorio reune os codigos, dados e modelos desenvolvidos para a disciplina de **Projeto Integrador III** do curso superior de tecnologia em Ciencia de Dados da FATEC. O foco central do projeto e o estudo, implementacao e avaliacao de arquiteturas de motores de busca e modelos de recuperacao textual.

---

## Identificacao do Grupo

* **Grupo:** APPA
* **Integrantes:**
  * Arthur Galvao
  * Pedro Henrique
  * Ailana

---

## Estrutura do Repositorio

A organizacao das pastas segue o padrao estrutural definido para as entregas do projeto:

```text
pi3/
├── consolidado/
│   └── 2026-09-04-appa-entrega1-MotorDeBusca.md
├── estrutura/
│   ├── corpus/
│   │   └── .gitkeep
│   └── código/
│       ├── 2026-08-20-appa-MotorDeBusca.r
│       ├── 2026-08-25-appa-MotorBuscaTfIdf.r
│       └── 2026-09-04-appa-MotorBuscaBM25.r
├── readme.md
└── to delete/
    └── .gitkeep
```

---

## Descricao dos Arquivos de Codigo

1. **[2026-08-20-appa-MotorDeBusca.r](estrutura/código/2026-08-20-appa-MotorDeBusca.r):**
   Primeira versao didatica do motor com contagem direta de termos e extracao de sentencas dos artigos dos clubes.

2. **[2026-08-25-appa-MotorBuscaTfIdf.r](estrutura/código/2026-08-25-appa-MotorBuscaTfIdf.r):**
   Implementacao baseada no modelo de espaco vetorial classico e busca booleana. Realiza a ponderacao linear TF-IDF e calcula a similaridade entre os documentos e a consulta atraves do cosseno.

3. **[2026-09-04-appa-MotorBuscaBM25.r](estrutura/código/2026-09-04-appa-MotorBuscaBM25.r):**
   Implementacao do modelo probabilistico BM25 (Best Matching 25), considerado o baseline moderno para recuperacao lexical na industria. Inclui suporte a calibracao dinamica de hiperparametros e comparativo direto de ranqueamento contra o TF-IDF.

---

## Fundamentos Teoricos: Do TF-IDF ao BM25

### 1. Limitacoes do Modelo Vetorial (TF-IDF)

Nos modelos vetoriais convencionais:
* **Crescimento linear da frequencia:** A 10ª repeticao de uma palavra em um texto recebe exatamente o mesmo incremento de peso que a 2ª repeticao, ignorando o efeito pratico de retornos decrescentes de relevancia.
* **Vies de extensao documental:** Textos longos acumulam termos naturalmente, o que pode inflar artificialmente a pontuacao em relacao a documentos curtos e focados.

### 2. A Ideia Probabilistica e o Fenomeno de Explosividade (Burstiness)

Na pratica textual, palavras de conteudo nao seguem uma distribuicao de Poisson simples com taxa unica. Se um documento aborda o tema, o termo aparece repetidas vezes; caso contrario, costuma aparecer zero vezes.

O modelo teorico de 2-Poissons introduz o conceito de *eliteness* (uma variavel latente que indica se o documento e genuinamente sobre aquele topico ou se apenas cita o termo de passagem). Como estimar quatro parametros ocultos por palavra em vocabularios de milhoes de termos e computacionalmente inviavel, Stephen Robertson propos uma aproximacao hiperbolica que preserva as propriedades essenciais:
* $w(0) = 0$ (ausencia do termo resulta em contribuicao nula).
* Curva estritamente crescente e concava (cada repeticao subsequente agrega menos evidencia).
* Saturacao em um teto finito ($k_1 + 1$).

### 3. A Formula Completa do BM25

A pontuacao atribuida a um documento $d$ diante de uma consulta $q$ e expressa pelo somatorio:

$$\text{BM25}(q, d) = \sum_{t \in q} \text{IDF}(t) \cdot \frac{f_{t,d} \cdot (k_1 + 1)}{f_{t,d} + K}$$

Onde:
* $f_{t,d}$: frequencia do termo $t$ no documento $d$.
* $N$: numero total de documentos no corpus.
* $\text{df}_t$: quantidade de documentos em que o termo $t$ ocorre.
* $|d|$: quantidade de palavras ativas no documento $d$.
* $\text{avgdl}$: comprimento medio dos documentos no corpus.

#### Componente A: IDF Probabilistico (Robertson-Sparck Jones)

$$\text{IDF}(t) = \log\left(\frac{N - \text{df}_t + 0.5}{\text{df}_t + 0.5} + 1\right)$$

* A parcela $+0.5$ atua como suavizacao para impedir divisao por zero caso o termo conste em todos os documentos ($N - \text{df}_t = 0$).
* A parcela $+1$ impede valores de IDF negativos para termos ultra-frequentes que aparecem em mais da metade do acervo.

#### Componente B: Frequencia Saturada e Hiperparametro $k_1$

Controla a velocidade em que a frequencia atinge o platô:
* Valores tipicos: $k_1 = 1.2$.
* Se $k_1 = 0$, a frequencia passa a ser desconsiderada e a busca assume comportamento booleano.
* Valores maiores de $k_1$ retardam a saturacao, aproximando a ponderacao do TF linear classico.

#### Componente C: Penalizacao por Tamanho ($K$ e Hiperparametro $b$)

O fator $K$ normaliza a extensao do texto em relacao a media do corpus:

$$K = k_1 \cdot \left(1 - b + b \cdot \frac{|d|}{\text{avgdl}}\right)$$

* Valores tipicos: $b = 0.75$.
* $b = 0$: ignora completamente a extensao do documento.
* $b = 1$: aplica normalizacao estrita, considerando que todo documento longo e fruto de prolixidade (verbosidade).
* O valor $0.75$ equilibra realisticamente prolixidade e cobertura de escopo.

---

## Como Executar

Os scripts foram desenvolvidos em R e utilizam pacotes da biblioteca padrao (`base`, `utils`, `stats`), dispensando instalacoes externas de pacotes de terceiros.

No terminal ou no RStudio, execute:

```R
source("estrutura/código/2026-09-04-appa-MotorBuscaBM25.r")
```
