# Wrapper for the external rmse computation in Fortran (compute one RMSE for each block and par. set)
get.rmse = function (block.idx, mc, flow.truth) {                  
  # Checks
  if (any(is.na(block.idx))) stop("NA not allowed in block.idx.")
  if (any(is.na(mc)))        stop("NA not allowed in block.idx.") #nrow stop("NA not allowed in mc.")
  if (any(is.na(flow.truth))) stop("NA not allowed in flow.truth.")
  # Defs
  num_blocks    = as.integer(nrow(block.idx))
  num_par_sets  = as.integer(ncol(mc))
  # Call the fortran subroutine
  out= .Fortran("getrmse",
    num_blocks    = num_blocks, 
    block_len     = as.integer(ncol(block.idx)),  
    block_idx     = block.idx,                  # already made sure that this is an integer type matrix 
    num_par_sets  = num_par_sets,
    series_len    = as.integer(nrow(mc)), 
    mc            = mc,                         # already made sure that this is a double type matrix 
    truth         = as.double(flow.truth), 
    rmse          = matrix(as.double(rep(0,num_par_sets*num_blocks)),ncol=as.integer(nrow(block.idx)))
  )
  return(out$rmse)
}

