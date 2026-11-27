# Regra do Tema 5 da Aula 08. Reutilizada na atividade e na busca do APPA.
mmr <- function(rk, k, rel, S, lambda) {               # rk: estagio 1; rel: 0 a 1; S: cossenos
  if (!length(rk) || k < 1) return(names(rk))
  k <- min(k, length(rk)); cand <- names(rk)[seq_len(k)]; esc <- character(0)   # candidatos (k <= N); escolhidos: nenhum
  for (passo in seq_len(k)) {                                  # um escolhido por passo
    pen <- sapply(cand, function(d) max(c(0, S[d, esc])))     # maior cosseno com os escolhidos (ou 0)
    v   <- lambda * rel[cand] - (1 - lambda) * pen      # o valor MMR de cada candidato
    esc <- c(esc, cand[which.max(v)]); cand <- cand[-which.max(v)]   # o melhor passa de cand para esc
  }
  c(esc, names(rk)[-(seq_len(k))])                             # cabeca MMR + cauda intacta
}

rerank_mmr <- function(rk, wn, k, lambda) {               # rk: estagio 1; wn: ix$wn
  if (!length(rk) || k < 1 || lambda == 1) return(names(rk))
  top <- head(names(rk), k)                               # so os k candidatos sao lidos
  if (max(rk[top]) <= 0) return(names(rk))                # escores todos <= 0: nao reordena
  S <- t(wn[, top, drop = FALSE]) %*% wn[, top, drop = FALSE]   # cossenos so entre os candidatos
  mmr(rk, k, rk[top] / max(rk[top]), S, lambda)           # relevancia = escore / o maior
}

redund <- function(r, wn, n = 3) {                        # o par mais parecido do top-n
  if (length(r) < 2L) return(NA_real_)
  t3 <- head(r, n); S3 <- t(wn[, t3, drop = FALSE]) %*% wn[, t3, drop = FALSE]   # cossenos do top-n
  max(S3 - diag(1, nrow = length(t3)))                    # sem a diagonal
}
