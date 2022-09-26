# Vectors
# Combine atomic vectors of the same type to create longer vectors

lgl_var <- c(TRUE, FALSE)
int_var <- c(1, 2, 3)
dbl_var <- c(1, 2.5, 3.0)
chr_var <- c("a", "b", "c")

# Input of multiple atomic vectors of the same type always flattens
flattened <- c(c(1, 2), c(3, 4))
print(flattened)

# Determine the type of a vector
print(typeof(lgl_var))
print(typeof(int_var))
print(typeof(dbl_var))
print(typeof(chr_var))

# Missing values
x <- NA > 5
print(x)

x <- !NA
print(x)

x <- TRUE | NA
print(x)

x <- FALSE & NA
print(x)
