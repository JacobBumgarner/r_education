# 6.2.3 First-class functions

f01 <- function(x) {
    sin(1 / x^2)
}

# anonymous function
lapply(mtcars, function(x) length(unique(x)))

# 6.2.4 invoking function with already constructed arguments
args <- list(1:10, na.rm = TRUE)
do.call(mean, args)

# 6.3 Function composition: multiple function calls
x <- runif(100)

# find standard deviation
square <- function(x) x^2
deviation <- function(x) x - mean(x)

sqrt(mean(square(deviation(x))))

out <- deviation(x)
out <- square(out)
out <- mean(out)
sqrt(out)

# use the binary operator
x %>%
    deviation() %>%
    square() %>%
    mean() %>%
    sqrt()
sd(x)


# 6.4 lexical scoping
# name masking
x <- 10

g01 <- function() {
    x
}

g01()

x <- 1

g02 <- function() {
    y <- 2
    i <- function() {
        z <- 3
        c(x, y, z)
    }
    i()
}
g02()

# 6.4.3
fresh_start <- function() {
    if (!exists("a")) {
        a <- 1
    } else {
        a <- a + 1
    }
    a
}
fresh_start()

# Dynamic lookup
x <- 10

g03 <- function() x + 1
g03()

x <- 5
g03()

# Lazy evaluation
h01 <- function(x) {
    10
}
h01(stop("This is an error"))

# 6.5.1 promises
y <- 10

h02 <- function(x, y) {
    y <- 100
    x + 1
}

h02(y)

# default arguments
x <- 1
h05 <- function(x = ls()) {
    a <- 1
    x
}

h05()
h05(ls())

# check for missing argument
h06 <- function(x = 10) {
    list(missing(x), x)
}

h06()
h06(10)
