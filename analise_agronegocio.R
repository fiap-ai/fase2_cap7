# GabrielMule_RM560586_fase2_cap7

# Configuração do espelho CRAN
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Carregando bibliotecas necessárias
if (!require(readr)) install.packages("readr")
if (!require(dplyr)) install.packages("dplyr")
if (!require(ggplot2)) install.packages("ggplot2")

library(readr)
library(dplyr)
library(ggplot2)

# Criando a pasta build se ela não existir
dir.create("build", showWarnings = FALSE)

# Importando os dados
dados <- read_csv("agronegocio_dados.xlsx", col_types = cols())

# Visualizando as primeiras linhas dos dados
print(head(dados))

# Convertendo a coluna de produção para numérica
dados$`Produção (milhões de toneladas)` <- as.numeric(dados$`Produção (milhões de toneladas)`)

# Análise exploratória da variável quantitativa: Produção (milhões de toneladas)

# Medidas de Tendência Central
media_producao <- mean(dados$`Produção (milhões de toneladas)`, na.rm = TRUE)
mediana_producao <- median(dados$`Produção (milhões de toneladas)`, na.rm = TRUE)
moda_producao <- as.numeric(names(sort(table(dados$`Produção (milhões de toneladas)`), decreasing = TRUE)[1]))

# Medidas de Dispersão
variancia_producao <- var(dados$`Produção (milhões de toneladas)`, na.rm = TRUE)
desvio_padrao_producao <- sd(dados$`Produção (milhões de toneladas)`, na.rm = TRUE)
amplitude_producao <- max(dados$`Produção (milhões de toneladas)`, na.rm = TRUE) - min(dados$`Produção (milhões de toneladas)`, na.rm = TRUE)

# Medidas Separatrizes
quartis_producao <- quantile(dados$`Produção (milhões de toneladas)`, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
percentis_producao <- quantile(dados$`Produção (milhões de toneladas)`, probs = seq(0, 1, 0.1), na.rm = TRUE)

# Análise gráfica
png("build/producao_por_safra.png")
ggplot(dados, aes(x = Safra, y = `Produção (milhões de toneladas)`)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Produção por Safra",
       x = "Safra",
       y = "Produção (milhões de toneladas)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

# Análise gráfica da variável qualitativa: Tipo de Cultura
png("build/producao_por_cultura.png")
ggplot(dados, aes(x = `Tipo de Cultura`, y = `Produção (milhões de toneladas)`)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Produção por Tipo de Cultura",
       x = "Tipo de Cultura",
       y = "Produção (milhões de toneladas)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

# Preparando os resultados
resultados <- data.frame(
  Medida = c("Média", "Mediana", "Moda", "Variância", "Desvio Padrão", "Amplitude"),
  Valor = c(media_producao, mediana_producao, moda_producao, variancia_producao, desvio_padrao_producao, amplitude_producao)
)

# Adicionando quartis e percentis
resultados <- rbind(resultados, 
                    data.frame(Medida = names(quartis_producao), Valor = as.numeric(quartis_producao)),
                    data.frame(Medida = paste0(names(percentis_producao), "%"), Valor = as.numeric(percentis_producao)))

# Exibindo os resultados
print(resultados)

# Salvando os resultados em um arquivo
write.csv(resultados, "build/resultados_analise.csv", row.names = FALSE)

# Exibindo um resumo dos dados
print(summary(dados$`Produção (milhões de toneladas)`))

# Melhorias adicionais

# Análise de correlação (assumindo que existe uma coluna 'Area_Plantada')
if ("Area_Plantada" %in% colnames(dados)) {
  correlacao <- cor(dados$`Produção (milhões de toneladas)`, dados$Area_Plantada, use = "complete.obs")
  print(paste("Correlação entre Produção e Área Plantada:", correlacao))
}

# Histograma
png("build/histograma_producao.png")
ggplot(dados, aes(x = `Produção (milhões de toneladas)`)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Histograma da Produção",
       x = "Produção (milhões de toneladas)",
       y = "Frequência") +
  theme_minimal()
dev.off()

# Box Plot
png("build/boxplot_producao.png")
ggplot(dados, aes(y = `Produção (milhões de toneladas)`)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Box Plot da Produção",
       y = "Produção (milhões de toneladas)") +
  theme_minimal()
dev.off()

# Análise de frequência e proporção para Tipo de Cultura
freq_cultura <- table(dados$`Tipo de Cultura`)
prop_cultura <- prop.table(freq_cultura)
print("Frequência por Tipo de Cultura:")
print(freq_cultura)
print("Proporção por Tipo de Cultura:")
print(prop_cultura)

# Análise de tendências
png("build/tendencia_producao.png")
ggplot(dados, aes(x = Safra, y = `Produção (milhões de toneladas)`, group = 1)) +
  geom_line() +
  geom_point() +
  labs(title = "Tendência da Produção ao Longo das Safras",
       x = "Safra",
       y = "Produção (milhões de toneladas)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

# Comentários e análises
cat("\n--- Análise de Impactos e Tendências ---\n")

cat("\nImpacto das políticas agrícolas:")
cat("\nAs políticas agrícolas têm um papel fundamental no desempenho do agronegócio. Analisando os dados de produção ao longo das safras, podemos observar [insira observações específicas baseadas nos dados]. Isso sugere que [insira conclusões sobre o impacto das políticas].")

cat("\n\nInovações tecnológicas:")
cat("\nO aumento da produtividade observado em algumas culturas pode ser atribuído a inovações tecnológicas. Por exemplo, [insira exemplos específicos baseados nos dados]. Isso demonstra a importância contínua do investimento em pesquisa e desenvolvimento no setor agrícola.")

cat("\n\nQuestões ambientais:")
cat("\nAo analisar os dados de produção e área plantada, notamos [insira observações sobre a relação entre produção e área]. Isso levanta questões importantes sobre sustentabilidade e uso eficiente da terra. [Insira mais análises sobre o impacto ambiental baseadas nos dados].")

cat("\n\nTendências de mercado:")
cat("\nA análise da produção por tipo de cultura ao longo das safras revela tendências interessantes. [Insira observações sobre as tendências observadas]. Isso pode indicar mudanças nas preferências de mercado ou adaptações às condições climáticas e econômicas.")

cat("\n\nRecomendações para desenvolvimento sustentável:")
cat("\nCom base na análise dos dados, recomendamos:")
cat("\n1. [Insira recomendação baseada nos dados]")
cat("\n2. [Insira recomendação baseada nos dados]")
cat("\n3. [Insira recomendação baseada nos dados]")
cat("\n\nEstas recomendações visam promover um crescimento sustentável do agronegócio brasileiro, equilibrando produtividade, inovação e responsabilidade ambiental.")
