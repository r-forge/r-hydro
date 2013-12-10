# Function to set up a validation function for a model. To be called from modelCreate-functions.
# The inputs are:
#   HMData-object - input variables or response variables
#   gridsEqual - logical, whether the grid parameters should all be equal. Could be
#               TRUE - just a check
#               Minimum - Use lowest resolution and smallest extent
#               Maximum - Interpolate to highest resolution and largest extent
#               MinMax/MaxMin - combinations of the ones above
#               c(xres, yres, xmin, ymin, xmax, ymax, xcells, ycells) define grid directly
#               precipitation - This is to fix the resolution/extent to one of the grids
#                               also useful when data are given as points, not grids
#               Should this also include possibilities to check individual combinations of grids?
#               Will operate on both spatial and spacetime
#   freqEqual - logical, will check if the frequency of time series are equal. Could as above be
#               TRUE - just a check
#               Minimum - use the lowest frequency, minimum time range
#               Maximum - Interpolate to highest frequency, maximum time range
#               MinMax/MaxMin - combinations of the ones above
#               c(freq, tmax, tmin, nsteps) to fix the number of cells
#               precipitation - To match the time series with one of the temporal variables
#                               The last two are useful also if some of the time series
#                               are based on break points
#   parLimits - matrix with limits of parameters
#   modelName - name of model, to be able to generate the right name of the validation function.


# Function which checks resolutions of grids and time series
conformGrids = function(HMDataObject, gridsEqual = TRUE,
                            freqEqual = TRUE, parLimits, modelName) {}
