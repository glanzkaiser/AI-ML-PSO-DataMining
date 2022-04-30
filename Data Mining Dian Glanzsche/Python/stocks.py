# -*- coding: utf-8 -*-
"""
Created on Wed Jan 11 14:46:58 2017

@author: Dian Putri Indah M
"""

import pandas as pd
import pandas_datareader as web 
from pandas_datareader import data, wb  # Package and modules for importing data; this code may change depending on pandas version
import datetime
import numpy as np
import matplotlib.pyplot as plt   # Import matplotlib


 
# We will look at stock prices over the past year, starting at January 1, 2016
start = datetime.datetime(2007,1,1)
end = datetime.date.today()
 
# Let's get Apple stock data; Apple's ticker symbol is AAPL
# First argument is the series we want, second is the source ("yahoo" for Yahoo! Finance), third is the start date, fourth is the end date
saham1 = web.DataReader("ENRG.JK", "yahoo", start, end)
saham1["20d"] = np.round(saham1["Close"].rolling(window = 20, center = False).mean(), 2)
saham1["50d"] = np.round(saham1["Close"].rolling(window = 50, center = False).mean(), 2)
saham1["200d"] = np.round(saham1["Close"].rolling(window = 200, center = False).mean(), 2)
 

type(saham1)
saham1.head()

saham2 = web.DataReader("DOID.JK", "yahoo", start, end)
saham3 = web.DataReader("ADRO.JK", "yahoo", start, end)
 
# Below I create a DataFrame consisting of the adjusted closing price of these stocks, first by making a list of these objects and using the join method
stocks = pd.DataFrame({"ENRG.JK": saham1["Adj Close"],
                      "DOID.JK": saham2["Adj Close"],
                      "ADRO.JK": saham3["Adj Close"]})
 
stocks.head()

stocks.plot(grid = True)


