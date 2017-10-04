# Filter outlier samples by removing outlier samples.

filterGeneExpSamples <- function(exprt_design_merged, read_counts_merged, drug_names, dist_cutoffs, dist_cutoff_outlier=0.01, dist_cutoff_group=0.015, min_samples=3, filter_outlier=TRUE, keep_under_samples=FALSE, plot_clust=FALSE, verbose=FALSE, func_dir=NULL)
{
    # Load required library
    require(stats)

    # Load user-defined functions.
    if(is.null(func_dir)) func_dir <- getwd()

    source(file.path(func_dir, "getCutoff.R"), local=TRUE)
    source(file.path(func_dir, "clusterGeneExpSamples.R"), local=TRUE)
    source(file.path(func_dir, "selectGeneExpSamples.R"), local=TRUE)
    source(file.path(func_dir, "plotDivClustOfGeneExpSamples.R"), local=TRUE)

    # Sort and filter sample replicates in each drug-treated condition for
    # all drug groups and cell lines.
    exprt_design_merged_sorted <- NULL
    cell_lines <- levels(factor(exprt_design_merged$Cell))
    for(drug_name in drug_names)
    {
        exprt_design_merged_drug <- exprt_design_merged[exprt_design_merged$State==drug_name,]
        for(cell_line in cell_lines)
        {
            exprt_design_merged_drug_cell <- exprt_design_merged_drug[exprt_design_merged_drug$Cell==cell_line,]
            plates <- levels(factor(exprt_design_merged_drug_cell$Plate))
            for(plate in plates)
            {
                # Prepar the dataset of current condition.
                exprt_design_merged_drug_cell_plate <- exprt_design_merged_drug_cell[exprt_design_merged_drug_cell$Plate==plate,]
                sample_names_drug_cell_plate <- exprt_design_merged_drug_cell_plate$ID
                read_counts_drug_cell_plate <- read_counts_merged[,sample_names_drug_cell_plate]
                if(is.matrix(read_counts_drug_cell_plate)) read_counts_drug_cell_plate <- read_counts_drug_cell_plate[rowSums(is.na(read_counts_drug_cell_plate))==0,]
                else read_counts_drug_cell_plate <- read_counts_drug_cell_plate[!is.na(read_counts_drug_cell_plate)]

                # Calculate and plot divisive clusters for the samples in current cell line and drug-treated condition.
                title_text <- paste(drug_name, "on Cell", cell_line, "in Plate", plate)
                divclust_results <- clusterGeneExpSamples(read_counts=read_counts_drug_cell_plate, plot_clust=plot_clust, drug_name=drug_name, cell_line=cell_line, plate_number=plate, dist_cutoffs=dist_cutoffs, dist_cutoff_outlier=dist_cutoff_outlier, dist_cutoff_group=dist_cutoff_group, min_samples=min_samples, title_text=title_text, func_dir=func_dir)
                if(!is.matrix(read_counts_drug_cell_plate))
                {
                    # Plot an empty cluster.
                    if(!is.null(divclust_results))
                    {
                        ylim <- c(0, divclust_results$ylim)
                        hline <- divclust_results$hline
                    }
                    else
                    {
                        if(is.matrix(read_counts_drug_cell_plate) && ncol(read_counts_drug_cell_plate)>min_samples) ylim <- c(0, dist_cutoff_outlier)
                        else ylim <- c(0, dist_cutoff_group)
                        hline <- ylim[2]
                    }
                    plotDivClustOfGeneExpSamples(main=title_text, ylim=ylim, hline=hline, cex.main=1.75)
                }

                # Remove outlier samples.
                title_text <- paste(drug_name, "on Cell", cell_line, "in Plate", plate, "(Filtered)")
                if(filter_outlier)
                {
                    # Filter outlier sample replicates according to given cutoffs.
                    # Special handling of the CTRL in plate 3 of cell line B.
                    # Set cutoff values for outlier samples.
                    cutoff <- getCutoff(state=drug_name, cell=cell_line, plate=plate, cutoffs=dist_cutoffs, single=dist_cutoff_outlier, group=dist_cutoff_group)
                    sample_names_drug_cell_plate_sel <- selectGeneExpSamples(read_counts_drug_cell_plate, cutoff_outlier=cutoff[1], cutoff_group=cutoff[2], min_samples=min_samples, keep_under_samples=keep_under_samples, verbose=verbose, func_dir=func_dir)
                    sample_names_drug_cell_plate_idx <- sample_names_drug_cell_plate %in% sample_names_drug_cell_plate_sel
                    exprt_design_merged_drug_cell_plate <- exprt_design_merged_drug_cell_plate[sample_names_drug_cell_plate_idx,]
                    # Plot divisive clusters of filtered samples.
                    if(nrow(exprt_design_merged_drug_cell_plate) > 0)
                    {
                        sample_names_drug_cell_plate <- exprt_design_merged_drug_cell_plate$ID
                        read_counts_drug_cell_plate <- read_counts_merged[,sample_names_drug_cell_plate]
                        read_counts_drug_cell_plate <- read_counts_drug_cell_plate[rowSums(is.na(read_counts_drug_cell_plate))==0,]

                        # Calculate and plot divisive clusters for filtered samples after outlier removal.
                        clusterGeneExpSamples(read_counts=read_counts_drug_cell_plate, plot_clust=plot_clust, drug_name=drug_name, cell_line=cell_line, plate_number=plate, dist_cutoffs=dist_cutoffs, dist_cutoff_outlier=dist_cutoff_outlier, dist_cutoff_group=dist_cutoff_group, min_samples=min_samples, ylim=divclust_results$ylim, hline=divclust_results$hline, title_text=title_text, func_dir=func_dir)
                    }
                    else
                    {
                        # Plot an empty cluster because the number of samples is less than min_samples.
                        if(!is.null(divclust_results))
                        {
                            ylim <- c(0, divclust_results$ylim)
                            hline <- divclust_results$hline
                        }
                        else
                        {
                            if(is.matrix(read_counts_drug_cell_plate) && ncol(read_counts_drug_cell_plate)>min_samples) ylim <- c(0, dist_cutoff_outlier)
                            else ylim <- c(0, dist_cutoff_group)
                            hline <- ylim[2]
                        }
                        plotDivClustOfGeneExpSamples(main=title_text, ylim=ylim, hline=hline, cex.main=1.75)
                    }
                }
                else
                {
                    # All replicate samples pass through.
                    if(!is.null(divclust_results) && is.list(divclust_results) && !is.null(divclust_results$clust))
                    {
                        # Plot the original cluster again.
                        if(!is.null(divclust_results$ylim)) ylim <- c(0, divclust_results$ylim)
                        else ylim <- c(0, dist_cutoff_outlier)
                        if(!is.null(divclust_results$hline)) hline <- divclust_results$hline
                        else hline <- ylim[2]
                        plotDivClustOfGeneExpSamples(divclust=divclust_results$clust, main=title_text, ylim=ylim, hline=hline, cex.main=1.75)
                    }
                    else
                    {
                        # Plot an empty cluster.
                        ylim <- c(0, dist_cutoff_outlier)
                        hline <- ylim[2]
                        plotDivClustOfGeneExpSamples(main=title_text, ylim=ylim, hline=hline, cex.main=1.75)
                    }
                }
                # Save filtered samples.
                if(nrow(exprt_design_merged_drug_cell_plate)>0) exprt_design_merged_sorted <- rbind(exprt_design_merged_sorted, exprt_design_merged_drug_cell_plate)
            }
        }
    }

    # Return filtered targets.
    return(exprt_design_merged_sorted)
}
