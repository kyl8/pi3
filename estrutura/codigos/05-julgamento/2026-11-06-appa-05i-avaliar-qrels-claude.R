# R | 05i-avaliar-qrels-claude.R | executar na raiz de pi3 (ou nesta pasta).
# 1) kappa entre claude_leitura e codex_assistido (pares em comum);
# 2) metricas (P@3, AP, RR, nDCG) de bm25, cosseno, LSA k=20 e hibrido RRF com os qrels claude_leitura;
# 3) fracao de nao julgados no top-5 / top-10 de cada modelo.
# ATENCAO: claude_leitura e um SEGUNDO JUIZ LLM (Parte 2 da Aula 05). NAO substitui os qrels humanos
# e NAO deve ser misturado com eles. Os resultados vao para arquivos separados (sufixo ClaudeLeitura).
# Nao altera config.R nem os qrels existentes.
if (!file.exists("estrutura/codigos/motor-appa.R")) setwd("../../..")
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8"); source("estrutura/codigos/config.R", encoding = "UTF-8")
dir_csv <- "estrutura/codigos/05-julgamento/csv"; dir_res <- "estrutura/codigos/resultados"
LSA_K <- 20L; LIMIAR <- 2L; K <- 3L

cl  <- read.csv(file.path(dir_csv, "2026-11-06-appa-05-qrels-claude.csv"), stringsAsFactors = FALSE)
cx  <- read.csv(file.path(dir_csv, "2026-10-25-appa-05-qrels-assistidos.csv"), fileEncoding = "UTF-8", stringsAsFactors = FALSE)
cp  <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-corpus.csv"), fileEncoding = "UTF-8", stringsAsFactors = FALSE)
nec <- read.csv("estrutura/corpus/banco-de-dados/necessidades.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
ix  <- montar(setNames(cp$texto, cp$id), cfg); modelo_lsa <- lsa(ix, LSA_K)

# ---- 1) kappa claude x codex --------------------------------------------
m <- merge(cl[, c("consulta", "documento", "grau")], cx[, c("consulta", "documento", "grau")],
           by = c("consulta", "documento"), suffixes = c("_claude", "_codex"))
cat("Pares em comum:", nrow(m), "\n")
k3 <- kappa_cohen(m$grau_claude, m$grau_codex, 0:2)
kb <- kappa_cohen(as.integer(m$grau_claude >= LIMIAR), as.integer(m$grau_codex >= LIMIAR), 0:1)
cat("Kappa 3 niveis:\n"); print(k3$matriz); print(round(k3$medidas, 3))
cat("Kappa binario (>=2):\n"); print(kb$matriz); print(round(kb$medidas, 3))
disc <- m[m$grau_claude != m$grau_codex, ]; disc$texto <- substr(cp$texto[match(disc$documento, cp$id)], 1, 140)
write.csv(disc[order(disc$consulta, disc$documento), ], file.path(dir_res, "2026-11-06-appa-05i-DiscordanciasClaudeCodex.csv"), row.names = FALSE, fileEncoding = "UTF-8")
kt <- data.frame(escala = c("3 niveis (0/1/2)", "binario (>=2)"), n = nrow(m),
                 po = c(k3$medidas["po"], kb$medidas["po"]), pe = c(k3$medidas["pe"], kb$medidas["pe"]),
                 kappa = c(k3$medidas["kappa"], kb$medidas["kappa"]))
write.csv(kt, file.path(dir_res, "2026-11-06-appa-05i-KappaClaudeCodex.csv"), row.names = FALSE)

# ---- 2) metricas por modelo ---------------------------------------------
sistemas <- function(q) { bm <- ranking_bm25(q, ix, cfg); ls <- ranking_lsa(q, ix, cfg, modelo_lsa)
  list(bm25 = bm, cosseno = ranking_cosseno(q, ix, cfg), lsa = ls, hibrido = rrf(bm, ls, c = cfg$rrf_c)) }
res <- list(); nj <- list()
for (i in seq_len(nrow(nec))) {
  id <- nec$consulta[i]; q <- cl[cl$consulta == id, ]; grau <- setNames(q$grau, q$documento)
  rks <- sistemas(nec$texto_consulta[i])
  for (s in names(rks)) {
    r <- rks[[s]]; ord <- names(r[r > 0])                       # so o que casou algum termo
    mt <- metricas(ord, grau, LIMIAR, K)
    res[[length(res) + 1]] <- data.frame(consulta = id, conjunto = nec$conjunto[i], modelo = s, t(round(mt, 4)), R = sum(grau >= LIMIAR))
    for (kk in c(5, 10)) { top <- head(ord, kk); nj[[length(nj) + 1]] <- data.frame(consulta = id, modelo = s, k = kk, nao_julgados = sum(!top %in% names(grau)), de = length(top)) }
  }
}
res <- do.call(rbind, res); nj <- do.call(rbind, nj)
write.csv(res, file.path(dir_res, "2026-11-06-appa-05i-MetricasClaudeLeitura.csv"), row.names = FALSE)
write.csv(nj,  file.path(dir_res, "2026-11-06-appa-05i-NaoJulgadosClaudeLeitura.csv"), row.names = FALSE)
cat("\nMAP / MRR / P@3 / nDCG_grad por modelo e conjunto:\n")
agg <- aggregate(cbind(P_at_k, AP, RR, nDCG_grad) ~ modelo + conjunto, res, mean)
print(agg[order(agg$conjunto, agg$modelo), ], digits = 3, row.names = FALSE)
cat("\nTodos os 6 (media):\n"); print(aggregate(cbind(P_at_k, AP, RR, nDCG_grad) ~ modelo, res, mean), digits = 3, row.names = FALSE)
cat("\nAP por consulta:\n"); print(reshape(res[, c("consulta", "modelo", "AP")], idvar = "consulta", timevar = "modelo", direction = "wide"), digits = 3, row.names = FALSE)
cat("\nNao julgados (soma):\n"); print(aggregate(cbind(nao_julgados, de) ~ modelo + k, nj, sum), row.names = FALSE)
