library(lobstr)

# Binding
x <- c(1, 2, 3)

y <- x

print(obj_addr(x))
print(obj_addr(y))


# Trace the copy-on-modify of variables
x <- c(1, 2, 3)
cat(tracemem(x), "\n")
y <- x

y[[3]] <- 4L

untracemem(x)

# Function calls
f <- function(x) {
    x[[2]] <- 3
}

x <- c(1, 2, 3)
cat(tracemem(x), "\n")
z <- f(x)

untracemem(x)

# Lists
l1 <- list(1, 2, 3)
l2 <- l1
l2[[3]] <- 4

ref(l1, l2)

# Data frames
d1 <- data.frame(x = c(1, 2, 3), y = c(2, 4, 3))
d2 <- d1

# d2[, 2] <- d2[, 2] * 2
d2[1, ] <- d2[1, ] * 2
ref(d1, d2)

# Character vectors
x <- c("a", "a", "abc", "d")
ref(x, character = TRUE)

# Object size
obj_size(letters)
obj_size(ggplot2::diamonds)

x <- runif(1e6)
print(typeof(x))
obj_size(x)

# Modify-in-place
x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))
medians <- vapply(x, mean, numeric(1))
medians

# this for loop creates a copy of x three times in a single iteration...
for (i in seq_along(medians)) {
    x[[i]] <- x[[i]] - medians[[i]]
}

# Environments - modified in place
e1 <- rlang::env(a = 1, b = 2, c = 3)
e2 <- e1
e1$c <- 4
e2$c

# Exercise 2.5.3
# why does the following code not create a circular list?
x <- list()
x[[1]] <- x  # copy on modify creates a new list

# Unbinding and Garbage collection