#! /usr/bin/env python
numgroups = 80   #EDIT : number of groups wanted
csvfile = 'micrographs_ctf-00249.csv'
groupfile = 'groups.txt'


import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans

data=pd.read_csv(csvfile,sep=' ')
f1=data['_rlnBeamTiltX'].values
f2=data['_rlnBeamTiltY'].values
names=data['_rlnMicrographName'].values
X=np.array(list(zip(f1,f2)))
kmeans=KMeans(n_clusters=numgroups)
kmeans=kmeans.fit(X)
labels=kmeans.predict(X)
clusters=kmeans.cluster_centers_
f=open(groupfile,'w')
for i in range (len(names)):
    f.write("%s %f %f %d\n"%(names[i],f1[i],f2[i],labels[i]))
f.close

f2=open('centers.txt','w')
for i in range (numgroups):
   f2.write("%f %f\n" %(clusters[i][0],clusters[i][1]))
f2.close()


