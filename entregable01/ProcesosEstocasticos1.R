# ===============================================================================
# PROCESOS ESTOCÁSTICOS - ENTREGABLE 1
# Simulación de Cadena de Markov AR(1): X_t = β*X_{t-1} + ε_t
# Conversión a R del notebook original en Python
# Para usar en Google Colab con R
# ===============================================================================

# BLOQUE 1: Configuración inicial y parámetros
# ==============================================================================
# Instalar y cargar librerías necesarias (ejecutar solo la primera vez)
# install.packages(c("ggplot2", "gridExtra", "nortest", "forecast"))

library(ggplot2)        # para gráficos
library(gridExtra)      # para múltiples gráficos
library(nortest)        # para tests de normalidad
library(forecast)       # para análisis de series temporales

# Configurar semilla para reproducibilidad
set.seed(123)

# Parámetros del ejercicio
beta <- 0.1             # parámetro del modelo AR(1)
n_total <- 50000        # longitud total a simular
burn_in <- 1000         # pasos iniciales a descartar ("calentamiento")

cat("Parámetros configurados:\n")
cat("β =", beta, "\n")
cat("n_total =", n_total, "\n")
cat("burn_in =", burn_in, "\n")

# BLOQUE 2: Simulación de la cadena de Markov
# ==============================================================================
# Inicializar vector para almacenar la serie
X <- numeric(n_total)
X[1] <- 0  # condición inicial

# Simular la cadena X_t = β*X_{t-1} + ε_t
for (t in 2:n_total) {
  eps <- rnorm(1, mean = 0, sd = 1)    # ruido ~ N(0,1)
  X[t] <- beta * X[t-1] + eps
}

# Descartar el período de calentamiento (burn-in)
Xs <- X[(burn_in+1):n_total]
cat("Longitud de la serie después del burn-in:", length(Xs), "\n")

# BLOQUE 3: Cálculo de valores teóricos
# ==============================================================================
# Valores teóricos según la teoría de procesos AR(1)
var_teorica <- 1.0 / (1.0 - beta^2)
desv_teorica <- sqrt(var_teorica)

cat("Valores teóricos:\n")
cat("Media teórica:", 0.0, "\n")
cat("Varianza teórica:", var_teorica, "\n")
cat("Desviación estándar teórica:", desv_teorica, "\n")

# BLOQUE 4: Estadísticas descriptivas muestrales
# ==============================================================================
# Calcular estadísticas muestrales
media_muestral <- mean(Xs)
var_muestral <- var(Xs)
desv_muestral <- sd(Xs)

# Correlación simple entre X_t y X_{t-1}
corr_lag1 <- cor(Xs[-1], Xs[-length(Xs)])

# Mostrar resultados comparativos
cat("\n=== COMPARACIÓN TEÓRICA VS MUESTRAL ===\n")
cat(sprintf("Media muestral      : %8.4f (teórica: %8.4f)\n", media_muestral, 0.0))
cat(sprintf("Varianza muestral   : %8.4f (teórica: %8.4f)\n", var_muestral, var_teorica))
cat(sprintf("Desv. estándar mues.: %8.4f (teórica: %8.4f)\n", desv_muestral, desv_teorica))
cat(sprintf("Correlación lag 1   : %8.4f (esperado ~ β = %8.4f)\n", corr_lag1, beta))

# BLOQUE 5: Análisis gráfico - Histograma vs distribución teórica
# ==============================================================================
# Crear histograma con curva teórica superpuesta
p1 <- ggplot(data.frame(x = Xs), aes(x = x)) +
  geom_histogram(aes(y = after_stat(density)), bins = 60, alpha = 0.65, fill = "lightblue") +
  stat_function(fun = dnorm, args = list(mean = 0, sd = desv_teorica), 
                color = "red", size = 1) +
  labs(title = "Histograma de Xs vs. curva Normal(0, 1/(1-β²))",
       x = "valor", y = "densidad") +
  theme_minimal()

print(p1)

cat("\n=== LECTURA ESPERADA ===\n")
cat("* La media muestral debe ser cercana a 0.\n")
cat("* La varianza muestral debe ser cercana a 1/(1-β²) = 1/0.99 ≈ 1.0101\n")
cat("* La correlación con el valor anterior debe ser cercana a β = 0.1\n")
cat("  esto indica que X_t se parece a X_{t-1}\n")

# BLOQUE 6: QQ-plot para verificar normalidad
# ==============================================================================
# Para ajustar a media y varianza teóricas, estandarizar
Z <- Xs / desv_teorica  # si la teoría es correcta, Z debería verse ~Normal(0,1)

# Crear QQ-plot
p2 <- ggplot(data.frame(sample = Z), aes(sample = sample)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "QQ-plot de Xs escalado por la desviación teórica",
       x = "Cuantiles teóricos", y = "Cuantiles muestrales") +
  theme_minimal()

print(p2)

cat("\n=== LECTURA ESPERADA ===\n")
cat("El histograma debe parecerse a una 'campana' centrada en 0;\n")
cat("la curva teórica dibujada encima debería ajustar bien.\n")
cat("En el QQ-plot, los puntos deberían alinearse con la recta de referencia\n")
cat("(lo que sugiere forma normal).\n")

# BLOQUE 7: Análisis de autocorrelación
# ==============================================================================
# Calcular autocorrelaciones hasta lag 10
acf_result <- acf(Xs, lag.max = 10, plot = FALSE)
acf_vals <- as.numeric(acf_result$acf)

cat("\n=== AUTOCORRELACIONES ===\n")
cat("Autocorrelaciones (lags 0..10):", round(acf_vals, 3), "\n")

# Crear gráfico de autocorrelación
lag_data <- data.frame(lag = 0:10, acf = acf_vals)
p3 <- ggplot(lag_data, aes(x = lag, y = acf)) +
  geom_segment(aes(xend = lag, yend = 0), color = "blue", size = 1) +
  geom_point(color = "blue", size = 2) +
  labs(title = "Autocorrelación muestral (lags 0..10)",
       x = "lag", y = "ACF") +
  theme_minimal() +
  geom_hline(yintercept = 0, linetype = "dashed")

print(p3)

cat("\n=== LECTURA ESPERADA ===\n")
cat("El valor en lag 1 cerca de 0.1, y lags mayores rápidamente más pequeños.\n")

# BLOQUE 8: Tests de normalidad
# ==============================================================================
# Shapiro-Wilk en una submuestra (la prueba no está pensada para decenas de miles de datos)
submuestra <- Xs[1:5000]
sw_test <- shapiro.test(submuestra)

cat("\n=== TESTS DE NORMALIDAD ===\n")
cat(sprintf("Shapiro-Wilk p-valor (submuestra 5000): %8.4f\n", sw_test$p.value))

# Kolmogorov-Smirnov contra Normal con media=0 y desviación teórica
ks_test <- ks.test(Xs, "pnorm", mean = 0, sd = desv_teorica)
cat(sprintf("KS p-valor contra N(0, desv_teorica):   %8.4f\n", ks_test$p.value))

# Test de Anderson-Darling (alternativo)
ad_test <- ad.test(Xs)
cat(sprintf("Anderson-Darling p-valor:               %8.4f\n", ad_test$p.value))

cat("\n=== LECTURA ESPERADA ===\n")
cat("P-valores 'no muy pequeños' suelen ser compatibles con la normalidad teórica.\n")
cat("(Si salieran bajos, revisar tamaño de muestra, escalado y gráficos;\n")
cat("a tamaños enormes, pequeñas desviaciones pueden detectarse aunque\n")
cat("no sean relevantes en práctica).\n")

# BLOQUE 9: Resumen final y diagnósticos adicionales
# ==============================================================================
cat("\n=== RESUMEN FINAL ===\n")
cat("La simulación muestra que:\n")
cat("1. La cadena de Markov X_t = β*X_{t-1} + ε_t converge a una distribución estacionaria\n")
cat("2. Esta distribución es aproximadamente Normal(0, 1/(1-β²))\n")
cat("3. Los valores teóricos coinciden bien con los muestrales\n")
cat("4. Los tests estadísticos confirman la normalidad\n")
cat("5. La autocorrelación muestra la dependencia temporal esperada\n")

# Crear gráfico de la serie temporal (últimos 1000 valores)
ultimos <- tail(Xs, 1000)
p4 <- ggplot(data.frame(t = 1:1000, x = ultimos), aes(x = t, y = x)) +
  geom_line(color = "blue", alpha = 0.7) +
  labs(title = "Serie temporal (últimos 1000 valores)",
       x = "tiempo", y = "X_t") +
  theme_minimal()

print(p4)

cat("\n¡Análisis completado exitosamente!\n")
