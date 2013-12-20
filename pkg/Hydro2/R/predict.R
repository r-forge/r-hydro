setMethod("predict", signature = "HM",
    .local <- function (object, newdata = NULL, all = FALSE,
        probs = c(0.05, 0.95))
    {
      parameters = HMparameters(object)
      model = object@model
      for (ip in 1:length(parameters)) {
        model = names(parameters)[ip]
        lpred <- do.call(what = model, list(object))      
        if (model %in% names(HMpred(lpred))) {
          object@Pred = modifyList(object@Pred, lpred@Pred)
        } else {
          object@Pred = list(model = lpred@Pred)
        } 
      }
      object
    }
)


