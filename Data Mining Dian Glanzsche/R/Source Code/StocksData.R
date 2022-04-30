library(quantmod)
library(ggplot2)

#Get financial statements (IN mILLION USD)

getFinancials(Symbol="GOOG", src="google")

Total.Dividends<-GOOG.f$CF$A["Total Cash Dividends Paid",]

Total.Assets<-GOOG.f$BS$A["Total Assets",]
Total.Liabilities-GOOG.f$BS$A["Total Liabilities",]

Total.Revenue<-GOOG.f$IS$A["Revenue",]
Gross.Profit<-GOOG.f$IS$A["Gross Profit",]
Net.Income<-GOOG.f$IS$A["Income After Tax",]

View(Gross.Profit)

# STOCK CHART
barChart(JSMR.JK, theme = 'white', bar.type = 'hlc')

chartSeries(JSMR.JK, theme = 'white',"candlestick")
chartSeries(JSMR.JK, theme = 'white',"candlestick", subset="last 3 months")

# Add indicator
addBBands(n=20, sd=2, ma="SMA", draw = "bands", on=-1)
addRSI(n = 14, maType = "EMA" )
addEMA(n=5, wilder = FALSE, ratio = NULL, on = 1, overlay = TRUE, col="purple")
addEMA(n=20, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="red")
addEMA(n=50, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="blue")
addEMA(n=100, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="green")

# Volume Chart

count <-  table(ADHI.JK$ADHI.JK.Volume)
barplot(ADHI.JK$ADHI.JK.Volume)

mydf <- data.frame(ADHI.JK)

# Get currency rate
getSymbols(c("IDR=X"))

getSymbols("COP",src="yahoo", from = "2015-06-01", to = "2016-04-15") # from yahoo finance
getSymbols("EUR=X",src="yahoo",from="2005-01-01")
getSymbols("IDR=X",src="yahoo",from="2005-01-01")

getSymbols("GBP/USD",src="oanda", from="2014-05-30", to= "2014-06-14")
getSymbols("USD/IDR",src="oanda", from="2012-01-01")

chartSeries(IDR=X, theme = 'white',"candlestick")

# Make Currency Chart
chartSeries(GBPUSD, theme = 'white',"candlestick")
chartSeries(USDIDR, theme = 'white',"candlestick")

# Get todays data (tail) or oldest data (head)
tail(JSMR.JK)
head(JSMR.JK)

# Get stocks (FULL)
getSymbols("^JKSE",src="yahoo")

getSymbols(c("ADHI.JK"))
getSymbols(c("ADMG.JK"))
getSymbols(c("ADRO.JK"))
getSymbols(c("AGRO.JK"))
getSymbols(c("AKRA.JK"))
getSymbols(c("ANTM.JK"))
getSymbols(c("APLN.JK"))
getSymbols(c("ASRI.JK"))
getSymbols(c("ARTI.JK"))
getSymbols(c("ASII.JK"))

getSymbols(c("BEST.JK"))
getSymbols(c("BHIT.JK"))
getSymbols(c("BIPI.JK"))
getSymbols(c("BKSL.JK"))
getSymbols(c("BMTR.JK"))
getSymbols(c("BNLI.JK"))
getSymbols(c("BUMI.JK"))
getSymbols(c("BRMS.JK"))
getSymbols(c("BRPT.JK"))
getSymbols(c("BSDE.JK"))
getSymbols(c("BWPT.JK"))

getSymbols(c("CASA.JK"))
getSymbols(c("CPIN.JK"))
getSymbols(c("CTRA.JK"))
getSymbols(c("CTRP.JK"))

getSymbols(c("DEWA.JK"))
getSymbols(c("DGIK.JK"))
getSymbols(c("DILD.JK"))
getSymbols(c("DMAS.JK"))
getSymbols(c("ELSA.JK"))
getSymbols(c("ELTY.JK"))
getSymbols(c("ENRG.JK"))
getSymbols(c("ERAA.JK"))
getSymbols(c("EXCL.JK"))

getSymbols(c("GAMA.JK"))
getSymbols(c("GGRM.JK"))
getSymbols(c("GIAA.JK"))
getSymbols(c("GJTL.JK"))
getSymbols(c("GZCO.JK"))
getSymbols(c("HADE.JK"))
getSymbols(c("HRUM.JK"))

getSymbols(c("IATA.JK"))
getSymbols(c("ICBP.JK"))
getSymbols(c("INAF.JK"))
getSymbols(c("INCO.JK"))
getSymbols(c("INDF.JK"))
getSymbols(c("INDY.JK"))
getSymbols(c("INKP.JK"))
getSymbols(c("INDS.JK"))
getSymbols(c("INDX.JK"))
getSymbols(c("IPOL.JK"))
getSymbols(c("INPC.JK"))

getSymbols(c("JPFA.JK"))
getSymbols(c("JSMR.JK"))
getSymbols(c("KAEF.JK"))
getSymbols(c("KBLI.JK"))
getSymbols(c("KIJA.JK"))
getSymbols(c("KLBF.JK"))
getSymbols(c("KRAS.JK"))
getSymbols(c("KREN.JK"))

getSymbols(c("LCGP.JK"))
getSymbols(c("LEAD.JK"))
getSymbols(c("LMPI.JK"))
getSymbols(c("LPPF.JK"))
getSymbols(c("LTLS.JK"))
getSymbols(c("LPKR.JK"))
getSymbols(c("LSIP.JK"))

getSymbols(c("MAPI.JK"))
getSymbols(c("MAMI.JK"))
getSymbols(c("MCOR.JK"))
getSymbols(c("MDLN.JK"))
getSymbols(c("MDRN.JK"))
getSymbols(c("MEDC.JK"))
getSymbols(c("META.JK"))
getSymbols(c("MLPL.JK"))
getSymbols(c("MPPA.JK"))
getSymbols(c("MYOR.JK"))
getSymbols(c("MYRX.JK"))

getSymbols(c("NIKL.JK"))

getSymbols(c("PGAS.JK"))
getSymbols(c("PJAA.JK"))
getSymbols(c("PNBS.JK"))
getSymbols(c("PNLF.JK"))
getSymbols(c("PPRO.JK"))
getSymbols(c("PTPP.JK"))
getSymbols(c("PWON.JK"))

getSymbols(c("RAJA.JK"))
getSymbols(c("SCMA.JK"))
getSymbols(c("SDMU.JK"))
getSymbols(c("SIDO.JK"))
getSymbols(c("SMBR.JK"))
getSymbols(c("SMCB.JK"))
getSymbols(c("SMDM.JK"))
getSymbols(c("SMGR.JK"))
getSymbols(c("SMMT.JK"))
getSymbols(c("SRIL.JK"))
getSymbols(c("SSIA.JK"))
getSymbols(c("SSMS.JK"))

getSymbols(c("TELE.JK"))
getSymbols(c("TINS.JK"))
getSymbols(c("TLKM.JK"))
getSymbols(c("TMAS.JK"))
getSymbols(c("TMPO.JK"))
getSymbols(c("TOTL.JK"))
getSymbols(c("TOTO.JK"))
getSymbols(c("TPIA.JK"))
getSymbols(c("TRAM.JK"))

getSymbols(c("ULTJ.JK"))
getSymbols(c("UNTR.JK"))
getSymbols(c("UNSP.JK"))
getSymbols(c("WICO.JK"))
getSymbols(c("WIKA.JK"))
getSymbols(c("WINS.JK"))
getSymbols(c("WSBP.JK"))
getSymbols(c("WSKT.JK"))


# Make Stocks chart (FULL)

getSymbols("^JKSE",src="yahoo")
getSymbols(c("SOCI.JK"))


chartSeries(JKSE, theme = 'white',"candlestick")

chartSeries(ADHI.JK, theme = 'white',"candlestick", subset="last 3 months")

chartSeries(SOCI.JK, theme = 'white',"candlestick", subset="last 1 weeks")
chartSeries(SOCI.JK, theme = 'white',"candlestick", subset="last 52 weeks")


# Add indicator
addBBands(n=20, sd=2, ma="SMA", draw = "bands", on=-1)
addRSI(n = 14, maType = "EMA" )
addEMA(n=5, wilder = FALSE, ratio = NULL, on = 1, overlay = TRUE, col="purple")
addEMA(n=20, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="red")
addEMA(n=50, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="blue")
addEMA(n=100, wilder = FALSE, ratio = NULL,  overlay = TRUE, col="green")
