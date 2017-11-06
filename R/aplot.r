#' Residual diagnostic plots
#'
#' This function is to produce a histogram of residuals, a normal Q-Q plot, a residuals vs fitted values plot,
#' and an absolute residuals vs fitted values plot.
#' @param x A fitted model object.
#' @param ... Other graphical parameters (see \code{\link[lattice]{xyplot}} for details).
#' @examples
#' mydat <- ST.read.csv(system.file("extdata", "SB_yield.csv", package = "RAP"),
#'                      factorNames=c("Env","Genotype","Rep","Row","Column"),
#'                      traitNames="yield", env ="Env", rowSelect="HEAT05",
#'                      colSelect=c("Env","Genotype","Rep","Row","Column","yield"))
#' mymodel <- ST.run.model(data=mydat, design="res.rowcol", trait="yield",
#'                         genotype="Genotype", rep="Rep", row="Row", col="Column",
#'                         tryspatial="always")
#' aplot(mymodel$mfix)
#' #aplot(mymodel$mmix)
#' #c.f. in-built plot for "asreml" or "lme4"
#' #plot(mymodel$mfix)
#'
#' @export
aplot <- function(x,
                  ...) {
  # Diagnostic plots
  if (class(x) == "asreml") {
    resid <- x$residuals
    fitted <- x$fitted.values
  } else {
    resid <- residuals(x)
    fitted <- fitted(x)
  }
  trellisObj <- vector(mode = "list", length = 4)
  names(trellisObj) <- c("histogram", "qq", "residFitted", "absResidFitted")
  # Histogram of residuals
  trellisObj[["histogram"]] <- lattice::histogram(x = ~resid, xlab = "Residuals", ...)
  # Q-Q plot of residuals
  trellisObj[["qq"]] <- lattice::qqmath(~resid, xlab = "Normal quantiles",
                                        ylab = "Residuals", ...)
  # Residuals vs fitted values
  trellisObj[["residFitted"]] <- lattice::xyplot(resid ~ fitted,
                                                 panel = function(x, y, ...) {
                                                   lattice::panel.xyplot(x, y, ...,
                                                                         type = c("p", "g"))
                                                   lattice::panel.abline(h = 0)
                                                   lattice::panel.loess(x, y,
                                                                        col = "red", ...)
                                                 }, ylab = "Residuals",
                                                 xlab = "fitted values", ...)
  # Residuals vs fitted values
  trellisObj[["absResidFitted"]] <- lattice::xyplot(abs(resid) ~ fitted,
                                                    panel = function(x, y, ...) {
                                                      lattice::panel.xyplot(x, y, ...,
                                                                            type = c("p", "g"))
                                                      lattice::panel.loess(x, y,
                                                                           col = "red", ...)
                                                    }, ylab = "|Residuals|",
                                                    xlab = "fitted values", ...)
  adt <- lattice::trellis.par.get("add.text")
  xlb <- lattice::trellis.par.get("par.xlab.text")
  ylb <- lattice::trellis.par.get("par.ylab.text")
  zlb <- lattice::trellis.par.get("par.zlab.text")
  axt <- lattice::trellis.par.get("axis.text")
  syx <- lattice::trellis.par.get("plot.symbol")
  lattice::trellis.par.set("add.text", list(cex = 0.75))
  lattice::trellis.par.set("par.xlab.text", list(cex = 0.75))
  lattice::trellis.par.set("par.ylab.text", list(cex = 0.75))
  lattice::trellis.par.set("par.zlab.text", list(cex = 0.75))
  lattice::trellis.par.set("axis.text", list(cex = 0.75))
  lattice::trellis.par.set("plot.symbol", list(cex = 0.6))
  print(trellisObj[["histogram"]], position = c(0, 0.5, 0.5, 1), more = TRUE)
  print(trellisObj[["qq"]], position = c(0.5, 0.5, 1, 1), more = TRUE)
  suppressWarnings(print(trellisObj[["residFitted"]], position = c(0, 0, 0.5, 0.5),
                         more = TRUE))
  suppressWarnings(print(trellisObj[["absResidFitted"]], position = c(0.5, 0, 1, 0.5)))
  lattice::trellis.par.set("add.text", adt)
  lattice::trellis.par.set("par.xlab.text", xlb)
  lattice::trellis.par.set("par.ylab.text", ylb)
  lattice::trellis.par.set("par.zlab.text", zlb)
  lattice::trellis.par.set("axis.text", axt)
  lattice::trellis.par.set("plot.symbol", syx)
  invisible(trellisObj)
}
