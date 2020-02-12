# Format the digits after decimal point.

formatDecimal <- function(x, k=2, scientific=FALSE, drop0trailing=TRUE, trim=TRUE)
{
    # x is a numerical number.
    # k is the number of digits after decimal point.

    if(scientific)
    {
        r <- format(x, digits=k+1, scientific=TRUE, drop0trailing=drop0trailing, trim=trim)
    }
    else
    {
        r <- format(round(x, k), nsmall=k, scientific=FALSE, drop0trailing=drop0trailing, trim=trim)
    }
    return(r)
}
