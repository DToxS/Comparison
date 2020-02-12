# Open a new plot device.

openPlotDevice <- function(dev_type=NULL, file_name=NULL, dir_name=NULL, single_file=FALSE, width=NULL, height=NULL, pointsize=NULL, res=NA, background=NULL)
{
    # dev_type: type of plot device, e.g. "png", "jpeg"/"jpg", "svg", "pdf", and "eps".
    # file_name: main name of output plot file.
    # dir_name: name of output directory.
    # width: width of plotted image [Default: 2400px for PNG/JPEG and 17" for SVG/PDF/EPS].
    # height: height of plotted image [Default: 2400px for PNG/JPEG and 17" for SVG/PDF/EPS].
    # pointsize: point size of plotted image [Default: 24 for PNG/JPEG, 12 for SVG/PDF/EPS].
    # res: resolution in point per inch (ppi) of plotted raster image [Default: NA]
    # background: backgroud color for plotted image [Default: "white" for PNG/JPEG and "transparent" for SVG/PDF/EPS].

    # Check input arguments.

    # Check file name.
    if(!is.null(dev_type)) stopifnot(!is.null(file_name))
    # Check directory name.
    if(!is.null(dev_type))
    {
        if(is.null(dir_name)) dir_name <- "."
        else stopifnot(dir.exists(dir_name))
        dir_name <- normalizePath(dir_name)
    }
    # Check width and height: they must be either both NULL or both non NULL.
    stopifnot(!xor(is.null(width), is.null(height)))

    # Open specified plot device.

    if(!is.null(dev_type))
    {
        dev_type <- tolower(dev_type)
        if(dev_type == "png")
        {
            # Set default width and height for PNG plot.
            if(is.null(width) || is.null(height))
            {
                width <- 2400
                height <- 2400
            }

            # Set default background color.
            if(is.null(background)) background <- "white"

            # Set plot file.
            if(single_file) plot_file <- paste(file_name, dev_type, sep=".")
            else plot_file <- paste(file_name, "%03d", dev_type, sep=".")
            plot_file <- file.path(dir_name, plot_file)

            # Set default point size for PNG plot.
            if(is.null(pointsize)) pointsize <- 24

            # Open a PNG device for plotting.
            # Note: setting the background to transparent will make multiple plots
            # superimpose one after another.
            png(filename=plot_file, width=width, height=height, pointsize=pointsize, res=res, bg=background)
        }
        else if(dev_type == "jpeg" || dev_type == "jpg")
        {
            # Set default width and height for JPEG/JPG plot.
            if(is.null(width) || is.null(height))
            {
                width <- 2400
                height <- 2400
            }

            # Set default background color.
            if(is.null(background)) background <- "white"

            # Set plot file.
            if(single_file) plot_file <- paste(file_name, dev_type, sep=".")
            else plot_file <- paste(file_name, "%03d", dev_type, sep=".")
            plot_file <- file.path(dir_name, plot_file)

            # Set default point size for JPEG/JPG plot.
            if(is.null(pointsize)) pointsize <- 24

            # Open a JPEG/JPG device for plotting.
            # Note: setting the background to transparent will make multiple plots
            # superimpose one after another.
            jpeg(filename=plot_file, width=width, height=height, pointsize=pointsize, res=res, bg=background)
        }
        else if(dev_type == "svg")
        {
            # Set default width and height for SVG plot.
            if(is.null(width) || is.null(height))
            {
                width <- 17
                height <- 17
            }

            # Set default background color.
            if(is.null(background)) background <- "transparent"

            # Set plot file.
            if(single_file) plot_file <- paste(file_name, dev_type, sep=".")
            else plot_file <- paste(file_name, "%03d", dev_type, sep=".")
            plot_file <- file.path(dir_name, plot_file)

            # Set default point size for PDF plot.
            if(is.null(pointsize)) pointsize <- 12

            # Open a PDF device for plotting.
            svg(file=plot_file, width=width, height=height, pointsize=pointsize, bg=background, onefile=single_file)
        }
        else if(dev_type == "pdf")
        {
            # Set default width and height for PNG plot.
            if(is.null(width) || is.null(height))
            {
                width <- 17
                height <- 17
            }

            # Set default background color.
            if(is.null(background)) background <- "transparent"

            # Set plot file.
            if(single_file) plot_file <- paste(file_name, dev_type, sep=".")
            else plot_file <- paste(file_name, "%03d", dev_type, sep=".")
            plot_file <- file.path(dir_name, plot_file)

            # Set default point size for PDF plot.
            if(is.null(pointsize)) pointsize <- 12

            # Open a PDF device for plotting.
            pdf(file=plot_file, width=width, height=height, pointsize=pointsize, bg=background, onefile=single_file)
        }
        else if(dev_type == "eps")
        {
            # Set default width and height for EPS plot.
            if(is.null(width) || is.null(height))
            {
                width <- 17
                height <- 17
            }

            # Set default background color.
            if(is.null(background)) background <- "transparent"

            # Set plot file.
            if(single_file) plot_file <- paste(file_name, dev_type, sep=".")
            else plot_file <- paste(file_name, "%03d", dev_type, sep=".")
            plot_file <- file.path(dir_name, plot_file)

            # Set default point size for EPS plot.
            if(is.null(pointsize)) pointsize <- 12

            # Open a EPS device for plotting.
            setEPS()
            postscript(file=plot_file, width=width, height=height, pointsize=pointsize, bg=background, onefile=single_file)
        }
        else
        {
            warning("Plot to screen (other options: png, jpeg, jpg, svg, pdf or eps)")
            dev.new()
        }
    }
    else dev.new()

    # Create a set of device info to return.

    # Get the name of current plot device.
    cur_dev <- dev.cur()
    # Save the graphical parameters of current plot device.
    orig_pars <- par(no.readonly=TRUE)
    # Create a list.
    dev_info <- list(dev=cur_dev, pars=orig_pars)

    # Return the device info.
    return(dev_info)
}
