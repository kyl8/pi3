# R | aula07_funcoes.R | funcoes da teoria e da Parte D da Aula 07.
lsa <- function(ix, k) { # Decompoe a TF-IDF e guarda as primeiras k direcoes.
  if (length(k) != 1L || !is.finite(k) || k != floor(k) || k < 1 || k > min(dim(ix$w))) stop("k deve ser inteiro entre 1 e min(dim(ix$w)).") # Valida a dimensao possivel.
  s <- svd(ix$w) # Calcula U, valores singulares e V.
  U <- s$u[, seq_len(k), drop = FALSE]; rownames(U) <- ix$vocab # Identifica os termos nas linhas.
  D <- s$v[, seq_len(k), drop = FALSE] %*% diag(s$d[seq_len(k)], nrow = k) # Representa documentos por V_k Sigma_k.
  rownames(D) <- colnames(ix$w) # Preserva os identificadores dos documentos.
  list(U = U, S = s$d[seq_len(k)], D = D) # Retorna o modelo usado no folding-in.
} # Fecha a decomposicao truncada.
ranking_lsa <- function(consulta, ix, cfg, modelo) { # Projeta a consulta no espaco latente.
  q0 <- vetor_consulta(preparar(consulta, cfg), ix$vocab, ix$idf_tfidf) # Usa o mesmo vocabulario e preparo do corpus.
  qk <- t(modelo$U) %*% q0 # Dobra o vetor de termos nas k coordenadas.
  scores <- apply(modelo$D, 1, function(d) cosseno(qk, d)) # Mede similaridade com cada linha-documento.
  sort(scores, decreasing = TRUE) # Mantem todos os documentos em ordem.
} # Fecha o ranking denso.
rrf <- function(..., c = 60) { # Funde rankings por posicao, sem somar escalas de escores.
  rks <- list(...) # Aceita qualquer quantidade de rankings ordenados.
  ids <- unique(unlist(lapply(rks, names))) # Preserva a ordem do primeiro ranking nos empates.
  scores <- sapply(ids, function(d) sum(sapply(rks, function(r) { pos <- which(names(r) == d); if (length(pos)) 1 / (c + pos) else 0 }))) # Documento ausente nao soma parcela.
  sort(scores, decreasing = TRUE) # Devolve o ranking hibrido.
} # Fecha a fusao RRF.
ranking_modelo <- function(txt, modelo, ix, cfg, m = NULL, c = 60) { # Seleciona exatamente um dos tres modelos.
  if (!modelo %in% c("bm25", "lsa", "hibrido")) stop("modelo deve ser bm25, lsa ou hibrido.") # Evita uma configuracao invalida virar hibrido silenciosamente.
  if (modelo == "bm25") return(ranking_bm25(txt, ix, cfg)) # BM25 nao calcula SVD.
  if (is.null(m)) m <- lsa(ix, cfg$lsa_k) # Prepara o LSA somente quando ele sera usado.
  rl <- ranking_lsa(txt, ix, cfg, m) # Calcula a similaridade densa.
  if (modelo == "lsa") rl else rrf(ranking_bm25(txt, ix, cfg), rl, c = c) # Retorna LSA puro ou fusao.
} # Fecha a escolha de modelo.
ap_modelo <- function(q, modelo, m, consultas, qrels, ix, cfg) metricas(ranking_modelo(consultas[[q]], modelo, ix, cfg, m, c = cfg$rrf_c), qrels[[q]], cfg$limiar)[["AP"]] # Mede AP no mesmo gabarito.
ranking_motor <- function(txt, ix, cfg) ranking_modelo(txt, cfg$modelo, ix, cfg, c = cfg$rrf_c) # Aplica a decisao persistida no config.
