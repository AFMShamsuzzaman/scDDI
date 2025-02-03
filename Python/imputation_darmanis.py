import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import itertools

data=pd.read_csv('~/data/darmanis_process.csv')
dp= pd.read_csv('~/data/dp_darmanis.csv')
sim= pd.read_csv('~/data/sim_darmanis.csv')
data=data.values
data_imputed=data
dp=dp.values
sim=sim.values
nrow=len(data)
ncol=len(data[0])
nr=len(sim)

print(nrow)
print(ncol)
print(nr)


imp=np.empty((nrow,ncol))
for i, j in itertools.product(range(0,nrow), range(0,ncol)):
    imp[i][j]=0


impute=[]
impute=list()
for i, j in itertools.product(range(0,nrow), range(0,ncol)):
    if dp[i][j]>0.5:
        zval=data[i][j]
        temp=[]
        temp=list()
        for k in range(nr):
            if sim[j][k]>0.75:
                val=data[i][k]
                temp.append([i,k,val])
        ##regression
        t=np.array(temp)
        n=len(t)
        if(n==0):
            imp[i][j]=np.nan
        if(1<=n<5):
            X=t[:,1]
            y=t[:,2]
            m=round(np.average(y))
            impute.append([i,j,zval,m])
            imp[i][j]=m
            data_imputed[i][j]=m
        if(n>=5):
            X=t[:,1]
            y=t[:,2]
            ##Regression
            
            from sklearn.model_selection import train_test_split
            X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2)
            X_test=np.append(X_test,j)
            y_test=np.append(y_test,zval)
            
            # Fitting Decision Tree Regression to the dataset
            from sklearn.tree import DecisionTreeRegressor
            regressor = DecisionTreeRegressor(random_state=0)
            regressor.fit(X_train.reshape(-1,1), y_train.reshape(-1,1))
            y_pred = regressor.predict(X_test.reshape(-1,1))
            
            df = pd.DataFrame({'Cell_No':X_test.reshape(-1),'Real_Values':y_test.reshape(-1), 'Imputed_Values':y_pred.reshape(-1)})
            m=df.loc[df['Cell_No'] == j, 'Imputed_Values'].squeeze()
            impute.append([i,j,zval,m])
            imp[i][j]=m
            data_imputed[i][j]=m
    else:
        imp[i][j]=np.nan


import csv

with open("~/data/darmanis_imputed.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(data_imputed)

