# defines general method to extract clean item data.

extract <- function(x, data) {
  UseMethod("extract")
}

extract.default <- function(x, ...) {
  stop(paste("No extract method defined for class:", class(x)[1]))
}
