# Script para gerar o relatório em PDF usando tinytex

# Instalar e carregar o pacote tinytex
if (!require(tinytex)) install.packages("tinytex")
library(tinytex)

# Verificar se o LaTeX está instalado e instalá-lo se necessário
if (!tinytex::is_tinytex()) tinytex::install_tinytex()

# Gerar o PDF
tryCatch({
  tinytex::pdflatex("relatorio_agronegocio.tex")
  file.rename("relatorio_agronegocio.pdf", "build/relatorio_agronegocio.pdf")
  cat("Relatório em PDF gerado com sucesso usando tinytex.\n")
}, error = function(e) {
  cat("Erro ao gerar o relatório em PDF:", conditionMessage(e), "\n")
  cat("Por favor, verifique se o LaTeX está instalado corretamente no seu sistema.\n")
})

cat("Por favor, verifique o arquivo 'relatorio_agronegocio.pdf' na pasta 'build'.\n")
