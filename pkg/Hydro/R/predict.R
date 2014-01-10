setMethod("predict", signature = "HM",
    .local <- function (object)
    {
        model = gsub("HM", "", class(object))
        pred <- do.call(what = model, list(object))
    }
)


