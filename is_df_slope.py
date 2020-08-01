#! /usr/bin/env python

import sys
import pandas as pd
from sklearn import linear_model
import numpy as np

n = len(sys.argv)
if n>1:
	csvfile = sys.argv[1]
	data=pd.read_csv(csvfile)
	xdata=data['isx'].values
	ydata=data['isy'].values
	dfdata=data['df_diff'].values
	X=np.array(list(zip(xdata,ydata)))
	Y=np.array(dfdata)
	regr = linear_model.LinearRegression()
	regr.fit(X,Y)
	c=regr.score(X,Y)
	print 'Intercept: ' , regr.intercept_
	print 'X, Y Coefficients: ', regr.coef_
	print "Correlation: %f" %(c)
else:
	print "Usage: df_slope.py <defocus_image-shift file>\n"

