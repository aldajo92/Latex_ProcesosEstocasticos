# Guía de Estructura para Documentos LaTeX de Matemáticas

## 📋 Descripción General

Este documento describe la estructura y patrones utilizados en el documento de "Apuntes de Procesos Estocásticos" para que puedan ser replicados en otros documentos LaTeX académicos/matemáticos.

## 🏗️ Estructura del Documento

### 1. Preámbulo y Configuración

```latex
\documentclass[12pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amsmath, amssymb, amsthm}
\usepackage{geometry}
\usepackage{tikz}
\usetikzlibrary{automata,positioning}
\geometry{margin=1in}
\usepackage{enumitem}
\usepackage[framemethod=tikz]{mdframed}

% Eliminar sangría de párrafos
\setlength{\parindent}{0pt}
```

### 2. Definición de Entornos Personalizados

#### 📘 Definiciones (Caja Azul)

```latex
% Macro para definiciones
\newmdenv[
    backgroundcolor=blue!5,
    linecolor=blue!40,
    linewidth=1.5pt,
    roundcorner=5pt,
    innertopmargin=8pt,
    innerbottommargin=8pt,
    innerleftmargin=10pt,
    innerrightmargin=10pt,
    leftmargin=0pt,
    rightmargin=0pt
]{definicionbox}

\newcommand{\definicion}[1]{%
\begin{definicionbox}
\textbf{Definición}: #1
\end{definicionbox}
}
```

**Uso:** `\definicion{Contenido de la definición}`

#### 📗 Teoremas (Caja Verde)

```latex
% Macro para teoremas
\newmdenv[
    backgroundcolor=green!5,
    linecolor=green!50,
    linewidth=1.5pt,
    roundcorner=5pt,
    innertopmargin=8pt,
    innerbottommargin=8pt,
    innerleftmargin=10pt,
    innerrightmargin=10pt,
    leftmargin=0pt,
    rightmargin=0pt
]{teoremabox}

\newcommand{\teorema}[1]{%
\begin{teoremabox}
\textbf{Teorema}: #1
\end{teoremabox}
}
```

**Uso:** `\teorema{Enunciado del teorema}`

## 🎨 Patrones de Formato

### 1. Propiedades

Las propiedades se presentan sin caja especial:

```latex
\textbf{Propiedades}:
\begin{itemize}
    \item Propiedad 1
    \item Propiedad 2
\end{itemize}
```

### 2. Ejemplos

Los ejemplos se introducen con texto en negrita:

```latex
\textbf{Ejemplo}: Descripción del ejemplo
```

### 3. Ejercicios/Problemas

Similar a los ejemplos:

```latex
\textbf{Ejercicio}: Enunciado del ejercicio

\textbf{Problema}: Enunciado del problema
```

### 4. Demostraciones

Las demostraciones se introducen con:

```latex
\textbf{Demostración}: 
[Contenido de la demostración]
```

### 5. Soluciones

```latex
\textbf{Solución}:
[Desarrollo de la solución]
```

## 📊 Elementos Visuales

### 1. Diagramas con TikZ

El documento hace uso extensivo de TikZ para crear:

#### Grafos de Estados (Cadenas de Markov)

```latex
\begin{center}
\begin{tikzpicture}[->,>=stealth,shorten >=1pt,auto,node distance=3cm,semithick]
\tikzstyle{every state}=[fill=white,draw=black,text=black,minimum size=20pt]
\node[state] (A) {$0$};
\node[state] (B) [right of=A] {$1$};
\path
(A) edge[loop above] node{$\alpha$} (A)
(A) edge[bend left] node{$1-\alpha$} (B)
(B) edge[bend left] node{$\beta$} (A)
(B) edge[loop above] node{$1-\beta$} (B);
\end{tikzpicture}
\end{center}
```

#### Líneas de Tiempo

```latex
\begin{tikzpicture}[scale=1]
    \draw[->] (0,0) -- (5.2,0) node[right] {$t$};
    \draw[->] (0,0) -- (0,3.6) node[above] {Número de clientes};
    % ... más elementos
\end{tikzpicture}
```

### 2. Matrices

Las matrices se presentan usando el entorno estándar:

```latex
\begin{equation*}
P = \begin{pmatrix}
0.3 & 0.7 \\
0.1 & 0.9
\end{pmatrix}
\end{equation*}
```

### 3. Tablas

```latex
\begin{center}
\begin{tabular}{|c|c|c|c|c|}
\hline
$k$ & 0 & 1 & 2 & 3 \\
\hline
$P(D_{n+1}=k)$ & 0.3 & 0.4 & 0.2 & 0.1 \\
\hline
\end{tabular}
\end{center}
```

## 🔢 Ecuaciones y Notación

### 1. Ecuaciones en línea

```latex
Sea $X_n$ la variable...
```

### 2. Ecuaciones numeradas

```latex
\begin{equation}
f_i = \sum_{n=1}^{\infty} f_{ii}^{(n)}
\end{equation}
```

### 3. Ecuaciones sin numerar

```latex
\begin{equation*}
P(X_n = j) = \pi(j)
\end{equation*}
```

### 4. Ecuaciones con casos

```latex
\begin{equation*}
P(i,j) = 
\begin{cases}
p, & \text{si } j=i+1,\\
q, & \text{si } j=i-1,\\
r, & \text{si } j = i
\end{cases}
\end{equation*}
```

### 5. Alineación de ecuaciones

```latex
\begin{align*}
P(X_1 = 0) &= 0.3 \times 0.2 + 0.8 \times 0.1 \\
&= 0.06 + 0.08 \\
&= 0.14
\end{align*}
```

## 📝 Cajas Especiales Adicionales

Para destacar información importante, se pueden crear cajas personalizadas:

```latex
\begin{mdframed}[
    backgroundcolor=blue!10,
    linecolor=blue,
    linewidth=1pt,
    roundcorner=5pt,
    innertopmargin=10pt,
    innerbottommargin=10pt,
    innerleftmargin=10pt,
    innerrightmargin=10pt
]
Contenido destacado
\end{mdframed}
```

## 🗂️ Organización del Contenido

1. **Sección de datos generales**: Información del curso, profesor, horarios
2. **Contenido temático**: Organizado en secciones y subsecciones
3. **Definiciones conceptuales**: Usando las cajas azules
4. **Teoremas importantes**: Usando las cajas verdes
5. **Ejemplos prácticos**: Con desarrollo detallado
6. **Ejercicios propuestos**: Con soluciones cuando corresponda
7. **Propiedades y observaciones**: En formato de lista

## 💡 Recomendaciones de Uso

1. **Consistencia**: Mantener el mismo formato para elementos similares
2. **Claridad visual**: Usar las cajas de colores para destacar definiciones y teoremas clave
3. **Ejemplos abundantes**: Incluir ejemplos después de cada concepto importante
4. **Diagramas**: Usar TikZ para visualizar conceptos cuando sea apropiado
5. **Numeración**: Considerar usar `\newtheorem` para numeración automática si se requiere

## 🔧 Personalización

Para adaptar esta estructura a otros temas:

1. Cambiar los colores de las cajas según el tema
2. Agregar nuevos tipos de cajas (por ejemplo, para "Lemas", "Corolarios")
3. Ajustar los estilos de TikZ según el tipo de diagramas necesarios
4. Modificar los márgenes y espaciados según las necesidades

Esta estructura es especialmente útil para:
- Apuntes de clases de matemáticas
- Documentos de teoría matemática
- Guías de estudio
- Material didáctico con demostraciones
