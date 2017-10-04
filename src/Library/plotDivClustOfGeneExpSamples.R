# Plot divisive clusters for the dataset given state name and cell line.

plotDivClustOfGeneExpSamples <- function(divclust=NULL, main=NULL, ylim=NULL, hline=NULL, ...)
{
    # Load needed functions.
    require(cluster)

    # Check the data type.
    if(!is.null(divclust))
    {
        if(!inherits(divclust, "diana"))
        {
            warning("The input argument must be an object of \"diana\" class!")
            invisible(NULL)
        }

        # Plot divisive clusters.
        if(length(divclust$order) > 1)
        {
            if(is.null(ylim)) plot(divclust, main=main, xlab="Sample", which.plots=2, ask=FALSE, ...)
            else plot(as.dendrogram(divclust), main=main, ylab="Height", ylim=ylim, ...)
            # Add a horizontal line.
            if(!is.null(hline)) abline(h=hline, col="deeppink", lty=4)
        }
        else warning("At least 2 samples are required for cluster plot!")
    }
    else
    {
        # Plot an empty cluster.
        plot(as.dendrogram(hclust(dist(matrix(1,2,2)))), main=main, ylab="Height", ylim=ylim, leaflab="none", edgePar=list(lty=0), ...)
        if(!is.null(hline)) abline(h=hline, col="deeppink", lty=4)
    }

    # Return the results.
    invisible(divclust)
}
