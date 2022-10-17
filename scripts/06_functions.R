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
square <- function(x) x ^ 2
deviation <- function(x) x - mean(x)

sqrt(mean(square(deviation(x))))

out <- deviation(x)
out <- square(out)
out <- mean(out)
sqrt(out)

x %>%
    deviation() %>%
    square() %>%
    mean() %>%
    sqrt()
sd(x)
