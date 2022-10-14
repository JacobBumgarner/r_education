# Data Types in R

## Binding
Much like Python, objects are created and then bound to variables.

A single object can be bound to multiple variables.

## Variable naming
Variable naming conventions follow those of Python: variables must be named syntactically. 

## Copy-on-modify
When modifying an object that has been bound to multiple variables, the object will be
copied and modified and then rebound to the variable that was used to modify it.

## Function calls
Copying also applies to and within function calls. 

## Lists
Lists are similar to vectors in that they contain elements. However, lists do not directly
contain the elements are vectors do. Instead, they contain pointers to them.

Lists use copy-on-modify behavior, but they only create shallow copies. For example, if
you create list `l1 <- list(1, 2, 3)` and create a pointer `l2 <- l1`, the elements in `l2`
point to the same objects as the elements in `l1`. However, if you modify the third element of
`l2`, the third element and third element alone of `l2` will now point to a different object
than the third element of `l1`.

## List slicing
R uses 1 value index. R slicing includes the top index.

## Data frames
Data frames are list of vectors. Copy-on-modify applies to individual columns of the dataframe.

If you modify a single column, only that column is copied. However, if you modify a row, 
all affected columns are copied.

## Character vectors
Character vectors point to a global string pool.

## Object size
The size of an object in memory can be determined using `obj_size()`.

## Modify-in-place
When objects only have one pointer, they are efficiently modified in place.

R only knows if there are 0, 1, or many pointers to a single object. If an object is listed
as having many pointers, it won't revert to 1 automatically. 

Functions also create pointers to objects, making it hard to predict whether objects
will be modified in-place.

It can be difficult to identify when copies are being made. Use `tracemem` as needed to
find culprits of bottlenecks.

## Environments
Environments are objects that are always modified in place.

## Unbinding and garbage collection
R uses a tracing garbage collector. This means that it automatically tracks objects
to see how many references they have. These objects are deleted automatically when new
objects need to be created but memory is full. Garbage collection shouldn't be predicted
or necessary to call.

`gc()` can be called to manually free up memory, but it's not necessary.

