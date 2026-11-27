---
name: Busca APPA
description: Motor de busca de parágrafos dos clubes da Baixada Santista.
colors:
  primary: "#17583d"
  primary-hover: "#104832"
  ink: "#1b251f"
  muted: "#526259"
  passage: "#35453a"
  paper: "#fafbf8"
  field: "white"
  line: "#d6ded7"
  field-line: "#a9b9ab"
  wash: "#eef3ec"
  hit: "#f6e9b8"
typography:
  display:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "4.25rem"
    fontWeight: 500
    lineHeight: 1
    letterSpacing: "-0.04em"
  headline:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "1.125rem"
    fontWeight: 650
  title:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "1.2rem"
    fontWeight: 650
    lineHeight: 1.4
  body:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.55
  label:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "0.875rem"
  provenance:
    fontFamily: "DM Sans, system-ui, sans-serif"
    fontSize: "0.8125rem"
rounded:
  search: "32px"
  submit: "26px"
  secondary: "20px"
  settings: "12px"
spacing:
  page-gutter: "20px"
  examples-gap: "8px"
  rankings-gap: "52px"
components:
  search-field:
    backgroundColor: "{colors.field}"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.search}"
    padding: "6px 6px 6px 19px"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.field}"
    rounded: "{rounded.submit}"
    padding: "11px 20px"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  search-example:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    typography: "{typography.label}"
    rounded: "{rounded.secondary}"
    padding: "7px 13px"
  button-more:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    typography: "{typography.label}"
    rounded: "{rounded.secondary}"
    padding: "7px 13px"
  brand-link:
    textColor: "{colors.primary}"
  passage-title:
    textColor: "{colors.primary}"
    typography: "{typography.title}"
  search-settings:
    backgroundColor: "{colors.wash}"
    rounded: "{rounded.settings}"
    padding: "14px 18px"
---

# Design System — Busca APPA

## Overview

**Busca em primeiro plano.** A marca APPA, a tipografia e o campo central definem a página inicial. A lupa orienta a ação e o espaço livre mantém o foco na consulta.

Depois da busca, a lista de parágrafos ganha destaque. A ordem de leitura de cada resultado começa pelo clube e pela procedência, passa pelo título e termina no trecho.

## Colors

- **Verde APPA** na marca, no botão Pesquisar, nos títulos expansíveis e no contorno de foco. O botão escurece ao passar o ponteiro.
- **Papel claro e tinta escura** no fundo e no texto principal. A procedência usa o tom suave, e os parágrafos usam o verde-acinzentado escuro.
- **Branco, contorno e verde pálido** distinguem o campo, os divisores e as configurações abertas. O verde pálido também aparece ao passar o ponteiro sobre ações secundárias.
- **Amarelo palha** realça termos encontrados e mantém a cor do texto.

## Typography

DM Sans local, com arquivos WOFF2 de pesos 400 e 700 e alternativas `system-ui, sans-serif`. O título inicial usa tamanho de 4,25 rem e cai para 3,2 rem em telas estreitas. Os títulos dos resultados usam 1,2 rem com entrelinha de 1,4. O corpo usa 16 px com entrelinha de 1,55 e os parágrafos ocupam até 72 caracteres de largura tipográfica (`72ch`).

## Layout

Busca e configurações compartilham largura máxima de 690 px. Após a consulta, o título inicial dá espaço à busca no topo e à lista, com largura máxima de 730 px incluindo suas margens internas. Na comparação, a largura máxima é 1.220 px, com duas colunas e 52 px de intervalo. Até 760 px, os exemplos quebram linha e as configurações e listas de comparação ficam em coluna única, com 20 px de margem lateral nos principais blocos.

## Elevation & Depth

Superfícies planas. Divisores de 1 px separam cabeçalho, resultados e rodapé. O branco destaca o campo e a área verde pálida delimita as configurações.

## Shapes

O campo, o botão Pesquisar e os atalhos têm contorno arredondado, com raios de 32, 26 e 20 px, respectivamente. O painel de configurações usa cantos de 12 px.

## Components

- **Busca e exemplos.** O campo usa lupa verde e botão Pesquisar preenchido. Ao receber foco, o conjunto ganha contorno de 2 px. Os exemplos executam consultas prontas.
- **Configurações.** O painel começa recolhido e apresenta as opções de busca e reordenação. O controle do peso da relevância aparece ao selecionar MMR.
- **Resultados.** Posição, clube e procedência ficam acima do título verde. Ao expandir o título, o parágrafo completo substitui o excerto e pode exibir um link para a fonte online. O rodapé reúne créditos e o link da licença.
- **Comparação.** O resumo mostra a semelhança do par mais parecido entre os três primeiros, antes e depois da reordenação. As duas listas mantêm o mesmo estilo e indicam a posição anterior quando ela muda.
