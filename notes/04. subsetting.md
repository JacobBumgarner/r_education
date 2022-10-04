# Subsetting

Subsetting operators in R allow you to slice and select various components of data
structures.

Subsetting occurs with three different subsetting operators:
`[[`, `[`, and `$`.

Subsetting operators interact different with different data structures.

Subsetting and assignment can be combined.

## 4.2.1 Atomic Vectors
`[]` can be used to subset vectors.

Positive integers return the element at that position,
and positive integers can be repeated to return the same element multiple times.

Negative integers exclude the element at that position.

Character vectors can be used to subset named elements.

## 4.2.2 Lists
When subsetting lists, using `[` returns a list, `[[`` and `$` return elements from the
list.

## 4.2.3 Matrices and arrays
Matrices and arrays are stored in column-major order. 

Subsetting matrices and arrays can be done with integers, vectors, and matrices.

Returned results are by default dropped to the lowest dimension.

You can treat matrices and arrays as if they were a 1D vector and can subset them with
corresponding integers.

## 4.2.4 Data frames
Data frame subsetting is similar to lists and matrices.

A single index returns columns.

## 4.2.5 Preserving dimensionality
To preserve dimensionality when subsetting, `drop = FALSE` must be included in the slice.

# 4.3. Selecting a single element
`[` always returns a list. `[[` returns the object at that position.

## 4.3.1 [[

## 4.3.2 $
The `$` does partial matching when subsetting.

## 4.3.3 Missing and out-of-bounds indices

## 4.3.4 @
`@` acts as a more restrictive `$` and won't return partially matched names.

# 4.4 Subsetting and assignment
Subsetting operators can be used to assign new values to a vector

Basic form:
`x[i] <- value`

`NULL` assignment can be used to remove components from lists.

# 4.5 Example applications (see R file)