library(gtrendsR)

usr <- "dianputriim@gmail.com"
psw <- "Usisayang220613"
gconnect(usr, psw)

lang_trend <- gtrends(c("ELTY","MDRN", "BRMS","ENRG"),geo = "ID", res="7d")
plot(lang_trend)
