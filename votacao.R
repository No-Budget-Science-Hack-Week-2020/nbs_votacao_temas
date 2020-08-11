library(data.table)
library(openssl)
library(tidyverse)
library(mltools)
library(ggdendro)

# df <- as.data.frame(fread("dados votacao.csv"))
# df$hash = sapply(X = df$Nome,FUN = md5)
# df$Nome <- NULL
# write.csv(df,file = "dados_votacao_hash.csv" )

df <- as.data.frame(fread("dados_votacao_hash.csv"))
df <- df[,-c(1,2)]

df$hash <- as.factor(df$hash)
df$Temas <- as.factor(df$Temas)


df_temas_espalhados <- one_hot(as.data.table(df),cols = "Temas" )

df_temas_agrupados_por_pessoa <- newdata %>% group_by(hash) %>%
  summarize_all(sum)

rownames(df_agrupado_por_pessoa) <- df_agrupado_por_pessoa[,1]
df_agrupado_por_pessoa <- df_agrupado_por_pessoa[,-1]

df_agrupado_por_tema = as.data.frame(t(df_agrupado_por_pessoa))

df_agrupado_por_tema = df_agrupado_por_tema[rowSums(df_agrupado_por_tema) >= 4,]


d = dist(df_agrupado_por_tema)
hc_temas = hclust(d)
ggdendrogram(hc_temas, rotate = TRUE)

