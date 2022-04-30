# -*- coding: utf-8 -*-
"""
Created on Thu Feb  8 00:50:23 2018

@author: Dian Putri Indah M
"""

import datetime as dt
import matplotlib as plt
from matplotlib import style
import pandas as pd
import pandas_datareader as web

style.use('ggplot')
start = dt.datetime(2008,9,1)
end = dt.date.today()

df=web.DataReader('ENRG.JK', 'yahoo', start, end)

print(df.tail(31))