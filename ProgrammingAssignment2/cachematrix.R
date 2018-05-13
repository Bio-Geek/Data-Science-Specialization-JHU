## These two functions cache the inverse of a matrix.
## The first function creates a special object - list of 4 elements,
## which contains a function to:
## 1)set the values of the matrix
## 2)get the values of the matrix
## 3)set the values of the inverse
## 4)get the values of the inverse
## The second function calculates the iverse using the list created
## with the first function. First, it checks if the inverse has
## already been calculated and, if so, it gets the inverse from the
## cache and skips the computation. Otherwise, it calculates the
## inverse of the data and sets the value of the inverse in the cache.

### Example of use:

#load the functions into environment.
### First, solve inverse and create a cache:
#x <- matrix(c(4,7,2,6), nrow=2, byrow=T)
#z <- makeCacheMatrix(x)
#cacheSolve(z)
### Then, on every next call of cacheSolve, it gets inverse matrix from cache:
#cacheSolve(z)


## This function creates a special object that can cache its inverse.

makeCacheMatrix <- function(x = matrix()) {
    ## Given a matrix creates and returns a list (representintation of matrix).
    
    m <- NULL
    set <- function(y) {
        x <<- y
        m <<- NULL
    }
    get <- function() x
    setsolve <- function(solve) 
    m <<- solve
    getsolve <- function() m
    
    list(set = set, get = get, setsolve = setsolve, getsolve = getsolve)
}

## This function computes the inverse of the special object returned
## by makeCacheMatrix. If the inverse has already been calculated (and the
## matrix has not changed), then cacheSolve should retrieve the inverse
## from the cache.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
    
    m <- x$getsolve()
    
    if(!is.null(m)) {
        message("Getting cached data!")
        return(m)
    } else {
    
    data <- x$get()
    m <- solve(data, ...)
    x$setsolve(m)
    m
    }
}
