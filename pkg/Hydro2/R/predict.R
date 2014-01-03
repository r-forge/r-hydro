setMethod("predict", signature = "HM",
    .local <- function (object, model = NULL, newdata = NULL, all = FALSE,
        probs = c(0.05, 0.95))
    {
      parameters = HMparameters(object, model)
      if (!is.list(parameters)) parameters = list(parameters = parameters)
      for (ip in 1:length(parameters)) {
        param = parameters[[ip]]
        model = param@model
        lpred <- do.call(what = model, list(object))      
        if (length(HMpred(object)) > 0) {
        #Update existing predictions using this model
          object@Pred = modifyList(object@Pred, lpred@Pred)
        } else {
          object@Pred = lpred@Pred
        } 
      }
      object
    }
)


