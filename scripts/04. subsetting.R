library(purrr)

# 4.2.1 Atomic vector slicing
x <- c(1:4)

# Positive integers return the elements at those locations
x[c(3, 1)]

x[order(rev(x))]

x[c(1, 1)]  # repeated integers return the element n times

x[c(1.2, 1.6)]  # real numbers are truncated to integers

# Negative integers exclude those selections
x[c(-1, -3)]

# Logical integers return the element where TRUE
x[c(TRUE, FALSE, FALSE, TRUE)]
x[c(TRUE, FALSE)]

# Nothing returns the original vector
x[]

# Zero returns a zero-length vector
x[0]

# Subsetting works with named vectors as well
y <- setNames(x, letters[1:4])

y[c("a")]

# 4.2.2 Lists
x <- list(1, 2, 3)
x[1] 

x[[1]]

# 4.2.3 Matrices and arrays
m <- matrix(1:9, nrow = 3)
m[1:3, 3]

m[1:2, 2:3]

vals <- outer(1:5, 1:5, FUN = "paste", sep = "*")
vals

vals[c(1, 15)]

select <- matrix(ncol = 2, byrow = TRUE, c(
    1, 1,
    3, 1,
    2, 4
))

vals[select]
select

# 4.2.4 Data frames
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df

df[1:3]  # selects the first three columns

df[1:3, 2]  # selects the first three rows and then the second column

# 4.2.4 Preserving dimensionality
a <- matrix(1:4, nrow = 2)
a

a[1, 2]
a[1, 2, drop = FALSE]


# 4.3.1 [[]]
x <- list(1:3, "a", 4:6)

x[1]
x[[1]]

for (i in 2:length(x)) {
  out[[i]] <- fun(x[[i]], out[[i - 1]])
}

# 4.3.2. $
x <- list(abc = 1)
x

x$a
x[["a"]]

# 4.3.3
x <- list(
    a = list(1, 2, 3),
    b = list(3, 4, 5)
)
purrr::pluck(x, "a", 1)
purrr::pluck(x, "c", 1)
purrr::pluck(x, "c", 1, .default = NA)


# 4.4 Subsetting and assignment
x <- 1:5
x

x[c(1, 2)] <- c(101, 102)
x

x <- list(ab = 1, b = 2)
x

x$ab <- NULL
x


# 4.5.6 Removing columns from data frames
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df

df$z <- NULL
df

# 4.5.7 Logical subsetting
mtcars
mtcars[mtcars$gear == 5 | mtcars$gear == 3, ]


# 4.5.8 Boolean algebra vs. sets
x <- sample(10) < 4
x

which(x)

flip <- function(x, n) {
    out <- rep_len(TRUE, n)
    out[x] <- FALSE
    return(out)
}
swapped_x <- flip(which(x), length(x))
swapped_x

x

df <- data.frame(original = x, swapped = swapped_x)
df

a <- t(matrix(c(x, swapped_x), ncol = 2))
a
