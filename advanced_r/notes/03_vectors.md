# Vectors
Vectors are sequence objects. There are two main different flavors of vectors: atomic vectors
and lists. Atomic vectors all have the elements of the same type. Lists don't necessarily
have elements of the same type.

# Atomic Vectors
There are four types of atomic vectors: 
- Logical (bool + na); can be written as TRUE or FALSE or abbreviated T or F
- Integer
- Double
- Character

Although these might be considered as scalars in other languages, they are all vectors
with lengths of 1.

# Long vectors with c()
C is short for combine and can be used to create vectors with lengths greater than 1.

e.g.,
`x <- c(1, 2, 3)`

# Determine the type of a vector
Determine the type of a vector using `typeof()`

Determine the length of a vector using `length()`

# Missing values
R represents missing values as `NA`. `NA` tends to be infectious except in the 
context of some logical statements.

Check to see if a vector has missing values using:
`is.na(x)`

# Testing and coercion
You can test to see if a vector is a specific type using `is.*()`

Vectors can be coerced into types in a fixed order:
character -> double -> integer -> logical

Elements will be converted to NA if they cannot be coerced.

# 3.3 Attributes
The set of atomic vectors does not include data structures like matrices, arrays,
factors, or date-times. These types are built on top of atomic vectors by adding
attributes.

## 3.3.1 Getting and setting
Attributes are name-value pairs

Attributes can be retrieved and modified with: `attr()`.

They can be retrieved in masse with: `attributes()`
and can be set in masse with: `structure()`.

Attributes are temporary. They are lost by most operations.

Only two attributes are routinely preserved:

- Names: a character vector giving each element a name
- Dim: an integer vector used to turn vectors into matrices or arrays

## 3.3.2 Names
Vectors can be named in three ways:

- during creation
- through assignment via `names()`
- using `setNames()`

Avoid using attr(x, "names")

Unname vectors using `unname()` or `names(x) <- NULL`

## 3.3.3 Dimensions
Matrices and arrays can be created with `matrix()` or `array()`, or by using the
assignment form of `dim()`.

# 3.4 S3 Atomic Vectors
The most important vector attribute is `class`. 

Four important S3 vectors:

- Categorical data: **factor** vectors
- Dates: **Date** vectors
- Date-times: **POSIXct** vectors
- Durations: **difftime** vectors

## 3.4.1 Factors
Factors are vectors that can only contain predefined values. They store categorical
data.

They have two attributes:

- `class`: "factor"
- `levels`: Defines the set of allowed values

Factors are useful when you know all of the possible values but they are not all present
in the given dataset. 

Ordered factors behave like regular factors, but the order of the levels is meaningful.
The order of the levels is determined by the order that is placed in. Otherwise, the order
is monotonic.

## 3.4.2 Dates
Daters are vectors built on top of double vectors. They have an "Date" class.

## 3.4.3 Date-times
Date-times contain a `tzone` attribute.

## 3.4.4 Durations
`difftimes` store differences of times as specified time units.

# 3.5 Lists
Lists are just vectors that contain pointers to individual objects. These objects can
be different types.

Lists can contain lists.

## 3.5.1 Creating
c() of lists and atomic vectors will coerce the vectors into a list

## 3.5.2 Testing and coercion
Lists can be coerced with `as.list()` and return `list` when `typeof()` or `is.list()`
are called.

`unlist()` can be used to convert lists into atomic vectors.

## 3.5.3 Matrices and arrays
List arrays can be created by applying dimensions to a list


# Data frames and tibbles
A data frame is a named list of vectors with attributes for columns (`names`), rows 
(`row.names`), and its class (`data.frame`).

Data frames have `rownames()` and `colnames()`. The `names()` of a dataframe are the
column names.

Data frames have `nrows()` and `ncols()`. A df's `length()` is equal to the column
count.

## 3.6.1 Creating
## 3.6.2 Row names
Rows can be named, but the author suggests that this is typically an undesirable
practice.
## 3.6.3 Printing

## 3.6.4 Subsetting
Dataframes can be sliced as if they were 1D lists or 2D matrices

To slice a column, either a lone column index can be used or the column name can be used.
To slice rows, a lone index can be used and followed by a comma.

Subsets of dataframes are not always dataframes. They can be vectors or matrices.

## 3.6.5 Testing

## 3.6.6 List columns
Data frames can have lists as columns

`I()` can be used to create columns directly from lists in data frames. I: Inhibit. 
This prevents the data frame from converting vectors to factors or dropping names.

## 3.6.7 Matrix and data frame columns
As long as the rows match the data frame rows, columns can also be matrices or arrays.

# 3.7 NULL