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

# Check for missing values
x <- c(1, NA, 3, NA)
print(is.na(x))

# 3.2.4 Coercing
chr <- c("a", 1)
print(chr)

chr <- as.numeric(chr)
print(chr)

x <- c(FALSE, FALSE, TRUE)
x <- as.numeric(x)
print(x)
summed <- sum(x)
avg <- mean(x)
sprintf("Summed: %f, Mean: %f", summed, avg)


# 3.3 Attributes
# 3.3.1 Getting and Setting
a <- 1:3
attr(a, "x") <- "abcdef"
attr(a, "x")

attr(a, "y") <- 4:6
str(attributes(a))

# or equivalently
a <- structure(
    1:3,
    x = "abcdef",
    y = 4:6
)
str(attributes(a))

# 3.3.2 Names
x <- c(a = 1, b = 2, c = 3)

x <- 1:3
names(x) <- c("a", "b", "c")

x <- setNames(1:3, c("a", "b", "c"))

x <- unname(x)
names(x) <- NULL

# 3.3.2 Dimensions
x <- matrix(1:6, nrow = 2, ncol = 3)
x

y <- array(1:12, c(2, 3, 2))
y

z <- 1:6
dim(z) <- c(3, 2)
z

# 3.4.1 Factors
x <- factor(c("a", "b", "b", "a"))
x

typeof(x)

attributes(x)

sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)

grade <- ordered(c("b", "b", "a", "c"), levels = c("c", "b", "a"))
grade

# 3.4.2 Dates
today <- Sys.Date()

typeof(today)
attributes(today)

date <- as.Date("1970-02-01")
unclass(date)

# 3.4.3 Date-times
now_ct <- as.POSIXct("2022-09-27 16:55", tz = "America/New_York")
now_ct

typeof(now_ct)
attributes(now_ct)

structure(now_ct, tzone = "Asia/Tokyo")

# 3.4.4 Durations
one_week_1 <- as.difftime(1, units = "weeks")
one_week_1

typeof(one_week_1)
attributes(one_week_1)

one_week_2 <- as.difftime(7, units = "days")
one_week_2

typeof(one_week_2)
attributes(one_week_2)


# 3.5.1 Creating Lists
l1 <- list(
    1:3,
    "a",
    c(TRUE, TRUE, FALSE),
    c(2.3, 5.9)
)

typeof(l1)
str(l1)

l2 <- list(list(list(1)))
l2

l3 <- list(list(1, 2), c(3, 4))
l3

l4 <- c(list(1, 2), c(3, 4))
l4

# 3.5.3 List-matrices and -arrays
l  <- list(1:3, "a", TRUE, 1.0)
dim(l) <- c(2, 2)
l
l[[2, 2]]


# 3.6 Data frames and tibbles
# 3.6.1 Creating
df1 <- data.frame(x = 1:3, y = letters[1:3])
df1

attributes(df1)

# 3.6.2 Row names
# Rows can be named in dataframes
df2 <- data.frame(
    age = c(35, 27, 18),
    hair = c("blond", "brown", "black"),
    row.names = c("Bob", "Susan", "Sam")
)

df2

df2["Bob", ]

# 3.6.4 Subsetting
a <- df1[1:2, 2]

# 3.6.5 Testing
is.data.frame(df2)

# 3.6.6 List columns
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)

df

df <- data.frame(
    x = 1:3,
    y = I(list(1:2, 1:3, 1:4))
)

df

# 3.6.7 Matrix columns
df <- data.frame(x = 1:3)

df$y <- matrix(1:9, nrow = 3)

df$z <- data.frame(a = 1:3, b = letters[1:3], stringsAsFactors = FALSE)

df

df[1, ]
