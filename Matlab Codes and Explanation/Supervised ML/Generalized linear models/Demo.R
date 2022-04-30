#
# GENERALIZED LINEAR MODEL
#
# ====================================================================================
# Construct some data for the demo's
meter <- c(38,26,22,32,36,27,27,44,32,28,31)
daya <- c(85,92,112,96,84,90,86,52,84,79,82)
akselerasi <- c(17,14.5,14.7,13.9,13,17.3,15.6,24.6,11.6,18.6,19.4)
silinder <- c(6,4,6,4,4,4,4,4,4,4,4)
Importance <- c(1,2,2,2,3,2,2,2,1,1,1)
Offset <- c(5,5,5,5,5,5,5,5,5,5,5)
SecondHand <- c(0,1,1,1,0,0,1,0,0,1,1)

# Construct data frames:
data <- data.frame(meter,daya,akselerasi,silinder,
                   Importance,Offset,SecondHand)

# Create some new data:
daya <- c(70,67,67,67,110)
akselerasi <- c(16.9,15,15.7,16.2,16.4)
silinder <- c(4,4,4,4,6)
dataNew <- data.frame(daya,akselerasi,silinder)

# ====================================================================================
# DEMO 1: Tentukan GLM dengan distribusi GLM dan link identitas.
mdl <- glm(meter~daya+akselerasi+silinder,data=data,
           family=gaussian(link=identity))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=12.2692) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

cat("Predict new values:")
predict(mdl, dataNew)

# DEMO 2: Cocokkan GLM dengan distribusi gamma.
mdl <- glm(meter~daya+akselerasi+silinder,data=data,
           family=Gamma(link=log))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=0.0133) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 3: Cocokkan GLM dengan distribusi gamma.
mdl <- glm(meter~daya+akselerasi+silinder,data=data,
           family=Gamma(link=log),weight=Importance)
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=0.0226) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 4: Cocokkan GLM dengan distribusi gamma dan probit link
mdl <- glm(SecondHand~daya+akselerasi+silinder,data=data,
           family=binomial(link=probit))
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=1.3067) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")

# DEMO 5: Gbinomial dist. dengan probit link, bobot dan offset
mdl <- glm(SecondHand~daya+akselerasi+silinder,data=data,
           family=binomial(link=probit),weight=Importance,offset=Offset)
R2 <- 1-(mdl$deviance/mdl$null.deviance)
pMSE <- mean(residuals(mdl,"pearson")^2)
dMSE <- mean(residuals(mdl,"deviance")^2)
summary(mdl,dispersion=2.3473) # dispersion parameter as calculated in Matlab.
cat("\nPearson MSE: ",pMSE,"\n\nDeviance MSE: ",dMSE,"\n\nMcFadden R^2: ",R2,"\n")


