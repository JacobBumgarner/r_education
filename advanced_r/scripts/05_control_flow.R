# 5.2 Choices

# basic if statement
x <- if (1 > 2) TRUE else FALSE

grade <- function(x) {
    if (x > 90) {
        grade <- "A"
    } else if (x > 80) {
        grade <- "B"
    } else if (x > 70) {
        grade <- "C"
    } else if (x > 60) {
        grade <- "D"
    } else {
        grade <- "F"
    }
    return(grade)
}

result <- grade(90)
result

## 5.2.2
x <- c(1:10)
result <- ifelse(x %% 5 == 0, "XXX", as.character(x))
result

## 5.2.3
x_option <- function(x) {
    if (x == "a") {
        option <- "option 1"
    } else if (x == "b") {
        option <- "option 2"
    } else {
        stop("Invalid option. Option must be either 'a' or 'b'.")
    }
}

result <- x_option("a")
result

x_option <- function(x) {
    switch(x,
        a = "option 1",
        b = "option 2",
        stop("Invalid option. Option must either be 'a' or 'b'.")
    )
}
result <- x_option("x")

result <- x_option("a")
result

result <- x_option("c")


# 5.3 Loops
x <- c(1:5)

a <- 0
for (i in 1:5) {
    a <- a + x[i]
    print(a)
}

x_new <- vector("numeric", length = length(x))
for (i in seq_along(x)) {
    x_new[i] <- x_new[i] + x[i] + 1
}
x_new
