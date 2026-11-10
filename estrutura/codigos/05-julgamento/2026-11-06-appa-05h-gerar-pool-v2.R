# R | 05h-gerar-pool-v2.R | executar na raiz de pi3 (ou nesta pasta).
# Gera o pool de julgamento com o MOTOR ATUAL (config.R + corpus congelado), sem rede.
# Motivo: o pool de setembro (05d) veio do script BM25 antigo (k1 = 1,2; 90 stopwords) e deixou
# de fora boa parte do top-5 dos rankings atuais; documento nao julgado conta como grau 0.
#
# Metodo (pooling do TREC): top-k de cada sistema, uniao sem duplicatas por consulta.
# O arquivo de pool NAO traz de qual sistema veio cada documento (isso enviesaria o juiz);
# a origem fica num arquivo de auditoria separado, que so deve ser aberto DEPOIS do julgamento.
if (!file.exists("estrutura/codigos/motor-appa.R")) setwd("../../..")
source("estrutura/codigos/motor-appa.R", encoding = "UTF-8")  # motor do curso + stemming APPA
source("estrutura/codigos/config.R", encoding = "UTF-8")       # cfg do grupo
K_POOL <- 10L        # top-k de cada sistema (decisao do grupo)
LSA_K  <- 20L        # dimensoes do LSA avaliadas (mesmo valor do config atual)
SEMENTE <- 42L       # ordem de exibicao reproduzivel

dir_csv <- "estrutura/codigos/05-julgamento/csv"
cp  <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-corpus.csv"), fileEncoding = "UTF-8", stringsAsFactors = FALSE)
docs <- setNames(cp$texto, cp$id)
ix  <- montar(docs, cfg)
nec <- read.csv("estrutura/banco-de-dados/necessidades.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
modelo_lsa <- lsa(ix, LSA_K)

sistemas <- function(q) {
  bm  <- ranking_bm25(q, ix, cfg)
  cos <- ranking_cosseno(q, ix, cfg)
  ls  <- ranking_lsa(q, ix, cfg, modelo_lsa)
  list(bm25 = bm, cosseno = cos, lsa = ls, hibrido = rrf(bm, ls, c = cfg$rrf_c))
}

pool <- list(); origem <- list()
set.seed(SEMENTE)
for (i in seq_len(nrow(nec))) {
  id <- nec$consulta[i]; rks <- sistemas(nec$texto_consulta[i])
  tops <- lapply(rks, function(r) names(head(r[r > 0], K_POOL)))   # escore 0 nao entra: nada casou
  uniao <- unique(unlist(tops, use.names = FALSE))
  uniao <- sample(uniao)                                           # ordem embaralhada, sem pista de ranking
  pool[[i]] <- data.frame(consulta = id, documento = uniao, ordem_exibicao = seq_along(uniao), stringsAsFactors = FALSE)
  origem[[i]] <- do.call(rbind, lapply(names(tops), function(s) data.frame(consulta = id, documento = tops[[s]], sistema = s, posicao = seq_along(tops[[s]]))))
}
pool <- do.call(rbind, pool); origem <- do.call(rbind, origem)
write.csv(pool,   file.path(dir_csv, "2026-11-06-appa-05-pool-v2.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(origem, file.path(dir_csv, "2026-11-06-appa-05-pool-v2-origem-AUDITORIA.csv"), row.names = FALSE, fileEncoding = "UTF-8")

antigo <- read.csv(file.path(dir_csv, "2026-09-15-appa-05-pool.csv"), stringsAsFactors = FALSE)
chave <- function(x) paste(x$consulta, x$documento)
cat("Pool v2:", nrow(pool), "pares | pool antigo:", nrow(antigo), "| pares novos:", sum(!chave(pool) %in% chave(antigo)), "\n")
print(table(pool$consulta))
