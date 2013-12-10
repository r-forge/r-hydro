setMethod("predict", signature = "HM",
    .local <- function (object, newdata = NULL, all = FALSE,
        probs = c(0.05, 0.95))
    {
        model = gsub("HM", "", class(object))
        pred <- do.call(what = model, list(object))
    }
)


