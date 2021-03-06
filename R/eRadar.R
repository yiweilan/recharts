#' Radar charts
#'
#' ECharts style radar charts.
#'
#' @param dat    data.frame or matrix, should have colnames and rownames.
#' @param limit  data.frame or matrix, 2 column, indicates the limit of each axis.
#' @param opt    option of ECharts.
#' @return The HTML code as a character string.
#' @export
#' @examples
#' require(plyr)
#' dat = ddply(iris, .(Species), colwise(mean))  
#' rownames(dat) = dat[,1]
#' dat = dat[, -1]
#' dat
#' plot(eRadar(dat))

eRadar = function(dat, limit=NULL, opt=list()) {
    # limit=NULL; opt=list()
    if(is.null(opt$legend$data)) {
        opt$legend$data = rownames(dat)
    }

    if(is.null(opt$legend$orient)) {
        opt$legend$orient = 'vertical'
    }

    if(is.null(opt$legend$x)) {
        opt$legend$x = 'left'
    }

    if(is.null(opt$legend$y)) {
        opt$legend$y = 'center'
    }	

    if(is.null(opt$toolbox$show)) {
        opt$toolbox$show = TRUE
    }

    if(is.null(opt$toolbox$feature$mark)) {
        opt$toolbox$feature$mark = TRUE
    }

    if(is.null(opt$toolbox$feature$dataView)) {
        opt$toolbox$feature$dataView = TRUE
    }

    if(is.null(opt$toolbox$feature$restore)) {
        opt$toolbox$feature$restore = TRUE
    }    
	
	if(is.null(opt$toolbox$feature$saveAsImage)) {
        opt$toolbox$feature$saveAsImage = TRUE
    }  
	
    if(is.null(opt$tooltip$trigger)) {
		opt$tooltip$trigger = 'axis'
    }
	
	if(is.null(limit)){
		limit = matrix(0, ncol(dat), 2)
		limit[,2] = apply(dat,2,max)
	}
	
	ind = data.frame(text=colnames(dat), min=limit[,1], max=limit[,2])
	indList = split(ind, 1:nrow(ind))
    names(indList) = NULL
	
	
	if(is.null(opt$polar)) {
        opt$polar =  vector("list", 1)
    } 
	if(is.null(opt$polar[[1]]$indicator)){
		opt$polar[[1]]$indicator = indList
	}
		
	datList = vector("list", nrow(dat))
	for(i in 1:nrow(dat)){
		datList[[i]]$name  = rownames(dat)[i]
		datList[[i]]$value = unnames(dat[i,])
	}
	names(datList) = NULL

	
	if(is.null(opt$series)) {
        opt$series =  vector("list", 1)
    } 
    if(is.null(opt$series[[1]]$type)) {
        opt$series[[1]]$type =  'radar'
    } 
    
    if(is.null(opt$series[[1]]$data)) {
        opt$series[[1]]$data = datList
    } 
	

	jsonStr <- toJSON(opt, pretty=TRUE)
	
	outList <- .rechartsOutput(jsonStr, charttype="eRadar")
	return(outList)
}