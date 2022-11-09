
data <- read.csv(
    file = "data/data.csv", header = FALSE
)
data <- as.vector(as.matrix(data))
data <- matrix(
    data, 4, 4,
    dimnames = list(
        c("GeneA", "GeneB", "GeneC", "GeneD"),
        c("Control", "Nitrogen", "Phosphate", "Potassium")
    )
)
data

# get the average expression of the rows
expression_average <- rowSums(data)
expression_average

# sort the data based on the average expression
sorted_genes <- data[order(expression_average, decreasing = TRUE), ]
sorted_genes
