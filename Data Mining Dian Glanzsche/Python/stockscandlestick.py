# -*- coding: utf-8 -*-
"""
Created on Sun Jan 15 22:54:23 2017

@author: Dian Putri Indah M
"""

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.finance as mpf
import datetime

start = (2016, 5, 1)
end = datetime.date.today()
 
quotes = mpf.quotes_historical_yahoo_ohlc("KLBF.JK", start, end)

quotes[:2]

fig, ax = plt.subplots(figsize=(15, 9))
fig.subplots_adjust(bottom=0.2)

#use Line2d
#mpf.plot_day_summary_oclh(ax, quotes, ticksize=3, colorup=’k’, colordown=’r’)#
mpf.candlestick_ohlc(ax, quotes, width=0.6, colorup="b", colordown="r")
#mpf.candlestick(ax, quotes, width=0.6, colorup=’b’, colordown=’r’)
plt.grid(True)
ax.xaxis_date()
# dates on the x-axis
ax.autoscale_view()

plt.setp(plt.gca().get_xticklabels(), rotation=30)
#raw_input(“Press Enter to continue…”)