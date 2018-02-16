context("gxeAmmi")

testTD <- createTD(data = testData, genotype = "seed",
                   env = "field", repId = "rep",
                   subBlock = "block", rowId = "Y", colId = "X",
                   rowCoordinates = "Y", colCoordinates = "X")

BLUEsList <- lapply(X = levels(testTD$env), FUN = function(e) {
  modelSp <- STRunModel(testTD[testTD$env == e, ], design = "rowcol",
                        traits = "t1")
  STExtract(modelSp, what = "BLUEs", keep = "env")
})
BLUEs <- createTD(Reduce(f = rbind, x = BLUEsList))

geAmmi <- gxeAmmi(BLUEs, trait = "t1")

test_that("output is of the right class", {
  expect_is(geAmmi, "AMMI")
  expect_is(geAmmi$envScores, "matrix")
  expect_is(geAmmi$genoScores, "matrix")
  expect_is(geAmmi$importance, "data.frame")
  expect_is(geAmmi$anova, "data.frame")
  expect_is(geAmmi$fitted, "matrix")
  expect_is(geAmmi$trait, "character")
  expect_is(geAmmi$envMean, "numeric")
  expect_is(geAmmi$genoMean, "numeric")
  expect_is(geAmmi$overallMean, "numeric")
})

test_that("environmental scores are correct", {
  expect_identical(dim(geAmmi$envScores), c(3L, 2L))
  expect_equal(as.numeric(geAmmi$envScores),
               c(0.62845165715004, -0.76565288355625, 0.13720122640621,
                 -0.521263063425786, -0.28362356842947, 0.804886631855256))
})

test_that("genotypic scores are correct", {
  expect_identical(dim(geAmmi$genoScores), c(15L, 2L))
  expect_equal(as.numeric(geAmmi$genoScores),
               c(-9.03548885189676, 23.6286547023355, -18.8274674051202,
                 -2.86319345697682, -20.2532814542818, -5.60451589942932,
                 15.890904767675, 17.3234738571798, -19.8353702353716,
                 -40.5749733846803, 29.7559863168777, -31.8404169542006,
                 10.5956342371608, 22.7935133265967, 28.846540434132,
                 4.84788386481566, -6.61910233870078, 2.48202048768148,
                 -19.3219159115538, -26.3173914503667, 33.1200694543671,
                 10.8002274326453, 14.2790380052302, 11.1895457659757,
                 -5.24232784776562, -18.8961354586767, 7.87551106495466,
                 -16.6827241724439, -29.6543178246965, 38.139618928534))
})

test_that("importance is correct", {
  expect_identical(dim(geAmmi$importance), c(3L, 3L))
  expect_equal(as.numeric(as.matrix(geAmmi$importance)),
               c(22.9903555201053, 0.56312, 0.56312, 20.2502014369027, 0.43688,
                 1, 9.26204080118966e-15, 0, 1))
})

test_that("anova is correct", {
  expect_identical(dim(geAmmi$anova), c(6L, 5L))
  expect_equal(as.numeric(as.matrix(geAmmi$anova)),
               c(14, 2, 28, 15, 13, 0, 9411.85347947378, 602.255102526225,
                 13140.7794724636, 7399.7902571717, 5740.98921529192, 0,
                 672.275248533841, 301.127551263112, 469.313552587986,
                 493.319350478113, 441.614555022456, NaN, 1.43246502221519,
                 0.641634041042651, NA, NaN, NaN, NA, 0.202673137690048,
                 0.53399701751975, NA, NaN, NaN, NA))
})

test_that("fitted values are correct", {
  expect_identical(dim(geAmmi$fitted), c(15L, 3L))
  expect_equal(as.numeric(as.matrix(geAmmi$fitted)),
               c(74.7151036023947, 84.6863159645868, 69.2058701507397, 72.4263349806975,
                 74.6775287748894, 84.3169610996821, 61.9016626250044, 76.4260688483351,
                 45.0089083719377, 55.73363594701, 127.386419996042, 35.3752613055704,
                 116.497846332665, 100.217877055618, 76.5100601280916, 86.8609340249904,
                 48.5699067294116, 94.4405197587103, 70.2236413536363, 95.0560345138503,
                 98.3982444561455, 40.7120064386264, 54.0659643770598, 73.717931801954,
                 109.450972152511, 79.8103619839368, 80.0330293449465, 96.1593160967035,
                 59.7916652292684, 43.7558126199591, 92.4168841106851, 71.1348816223969,
                 88.5804753444723, 55.0432001091191, 56.5602343685175, 137.826424971715,
                 75.2520401394752, 93.6861197612903, 76.4261282596411, 75.5480706295077,
                 94.5437476278872, 68.2950594560886, 96.0030198796434, 56.5285622765051,
                 119.752101742297))
})

test_that("means are correct", {
  expect_length(geAmmi$envMean, 3)
  expect_length(geAmmi$genoMean, 15)
  expect_equal(unname(geAmmi$envMean),
               c(77.0057236788843, 75.403089392114, 83.8397966866161))
  expect_equal(unname(geAmmi$genoMean),
               c(84.6643072460234, 68.1303681054651, 84.0756217513075, 65.897725481151,
                 75.4312658857524, 106.847210175848, 59.2885697343687, 74.7260509955617,
                 65.0509894778442, 80.2442262430096, 100.580176535955, 61.2344500355352,
                 102.886727436337, 72.1793681871304, 80.0059914967826))
  expect_equal(geAmmi$overallMean, 78.7495365858715)
})

geAmmi1 <- gxeAmmi(BLUEs, trait = "t1", nPC = 1)
test_that("options nPC functions properly", {
  expect_identical(ncol(geAmmi1$envScores), 1L)
  expect_identical(ncol(geAmmi1$genoScores), 1L)
  expect_identical(geAmmi1$envScores, geAmmi$envScores[, 1, drop = FALSE])
  expect_identical(geAmmi1$genoScores, geAmmi$genoScores[, 1, drop = FALSE])
  expect_identical(geAmmi1$importance, geAmmi$importance)
  ## Third PC is very close to zero.
  expect_warning(geAmmi1 <- gxeAmmi(BLUEs, trait = "t1", nPC = 3))
})

geAmmiNC <- gxeAmmi(BLUEs, trait = "t1", center = FALSE)
test_that("option center functions properly", {
  expect_identical(geAmmiNC$envScores, geAmmi$envScores)
  expect_equal(geAmmiNC$importance, geAmmi$importance)
  expect_equal(geAmmiNC$genoScores, geAmmi$genoScores)
})

geAmmiSC <- gxeAmmi(BLUEs, trait = "t1", scale = TRUE)
test_that("option scale functions properly", {
  expect_equal(as.numeric(geAmmiSC$envScores),
               c(0.626768915658202, -0.759970706409396, 0.172061767293741,
                 -0.515799519222585, -0.239140088865518, 0.822655987559285))
  expect_equal(as.numeric(as.matrix(geAmmiSC$importance)),
               c(1.26175320476596, 0.53067, 0.53067, 1.18658284593316, 0.46933,
                 1, 4.3080241892555e-16, 0, 1))
  expect_identical(geAmmiSC$anova[1:3, ], geAmmi$anova[1:3, ])
})