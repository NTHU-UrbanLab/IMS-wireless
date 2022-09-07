import dropbox # version 10.7.0
import time
import glob
import pandas as pd # version 1.1.3
import numpy as np # version 1.19.0
import plotly.express as px # version 4.14.3
import plotly.io as pio # version 4.14.3
import matplotlib.pyplot as plt # verison 3.3.2
import matplotlib # version 3.3.2
import os
from scipy import stats # version 1.5.2
from sklearn.decomposition import PCA # version 0.23.2
from sklearn import preprocessing # version 0.23.2
from sklearn.cluster import KMeans # version 0.23.2
import scipy.cluster.hierarchy as shc # version 1.5.2
from sklearn.cluster import AgglomerativeClustering # version 0.23.2

filetimetime = time.strftime(' %H:%M:%S')
date = time.strftime('%Y%m%d ')
print(os.getcwd() + " "+"is the current path")
# create folder
date = time.strftime('%Y%m%d/')
def Folder(directory):
    try:
        if not os.path.exists(directory):
            os.makedirs(directory)
    except OSError:
        print ('Error: Creating directory.')

Folder (date)
# check if the folder exists
filepath = 'C:/Users/RICK1208/Desktop/PU lab/Python/'
if os.path.exists(filepath+date ):
    print("The folder path exists\n")
else:
    print("The folder path doesn't exist\n")
# set an infinite loop
while True:
    print("start analysis")
# download the txt file
    access_token = 'L_vkZ7RTFrAAAAAAAAAAGAbFteFGT4--UULYMfGjcsKvrIUn0_3aJiS4-WM6IR5r'
    dbx = dropbox.Dropbox(access_token)
    filepath3 = 'C:/Users/RICK1208/Desktop/PU lab/Python/'
    filename = 'IMS'
    filepath = '/test_dropbox/'
    filetype = '.txt'
    number = '2'
    os.chdir(filepath3+date)
    for  i in range (1,1000):
        try:
            metadata, res = dbx.files_download(path = filepath + filename + str(i) + filetype)
            with open(filename + str(i) + filetype , "wb") as f:
                f.write(res.content)
        except:
            break
    ii = i-1
    IMS = ("IMS2.txt")
    path = r'C:/Users/RICK1208/Desktop/PU lab/Python/'
    all_files = glob.glob(path +date+ "/*.txt")
    li = []
    for filename in all_files:
        df = pd.read_csv(filename, delimiter='\t', index_col=None, header=7)
        li.append(df)
    frame = pd.concat(li, axis=1, ignore_index=True)
    test = np.array(frame)
    df = np.zeros((1399,i))
    print(test.shape)
    h = 0
    for w in range(1,2*(i-1),2):
        df[:,h] = test[:,w]
        h=h+1
    pdf= df.transpose()
    print(pdf.shape)
    print(pdf)
    if os.path.exists(IMS):
        print("The file exists\n")
# data processing
        print(len(frame.columns))
        a =int(len(frame.columns)/2)
        print(a)
        b = df[:,0:a]
        print(b.shape)
        p = b.shape
        c = np.zeros((a,8))
        for i in range (1,9):
            d = 175*i-175
            e = 175*i
            f = b[d:e,:]
            f = f.mean(axis=0)
            a = f.transpose()
            c[:,i-1] = f
       data = c
# PCA
        features = ['6~7','7~8','8~9','9~10','10~11','11~12','12~13','13~14']
        pca = PCA()
        pca.fit(data)
        pca_data =pca.data = pca.transform(data)
        pca_df = pd.DataFrame(pca.data)
        g = len(pca_df.columns)
        loadings = pca.components_.T * np.sqrt(pca.explained_variance_)
        #print(loadings)
# percentage of variance
        per_var = np.round(pca.explained_variance_ratio_*100,decimals=1)
        labels = ['PC'+str(x) for x in range(1,g+1)]
        date = time.strftime('%Y%m%d')
        print("The perventage of varience")
        print(per_var)
# loading plot
# Reference: Plot PCA loadings and loading in biplot in sklearn (like R’s autoplot). Stack Overflow. https://stackoverflow.com/questions/39216897/plot-pca-loadings-and-loading-in-biplot-in-sklearn-like-rs-autoplot
        filetimedate = time.strftime('%Y%m%d  ')
        filetimetime = time.strftime('%H:%M:%S')
        filetime = time.strftime("/%Y%m%d/")
        filepath1 = 'C:/Users/RICK1208/Desktop/PU lab/Python/'
        filepath2 = 'C:/Users/RICK1208/Desktop/PU lab/Python'
        x=np.linspace(start=-1,stop=1,num=500)

        y_positive=lambda x: np.sqrt(1-x**2) 
        y_negative=lambda x: -np.sqrt(1-x**2)
        plt.plot(x,list(map(y_positive, x)), color='blue')
        plt.plot(x,list(map(y_negative, x)),color='blue')
        x=np.linspace(start=-1,stop=1,num=30)
        plt.scatter(x,[0]*len(x), marker='_',color='blue')
        plt.scatter([0]*len(x), x, marker='|',color='blue')
        pca_values=pca.components_
        add_string=""
        columns =['7~8','8~9','9~10','10~11','11~12']
        for i in range(len(pca_values[0])):
            xi=pca_values[0][i]
            yi=pca_values[1][i]
            plt.arrow(0,0, dx=xi, dy=yi, head_width=0.01, head_length=0.02, 
                      length_includes_head=True)
            add_string=f" ({round(xi,2)} {round(yi,2)})"
            plt.text(pca_values[0, i], pca_values[1, i],s=columns[i] )
        plt.xlabel(f"PC1 ({round(pca.explained_variance_ratio_[0]*100,2)}%)")
        plt.ylabel(f"PC2 ({round(pca.explained_variance_ratio_[1]*100,2)}%)")
        plt.title('Loading plot '+'Date: '+ filetimedate+'Time: '+filetimetime,fontsize=15,loc = 'left')        
        plt.savefig(filepath1+filetime+"PCA-Loading plot.jpg" ,dpi = 300,bbox_inches='tight')
        print("Loading plot has been saved successfully in the folder: "+ date+"\n")
        plt.show(block=False)
        plt.pause(2)
        plt.close()
        filetimedate = time.strftime('%Y%m%d  ')
        filetimetime = time.strftime('%H:%M:%S') 
        filetime = time.strftime("/%Y%m%d/")
# scoring plot
        plt.title('PCA-Scoring plot  '+'Date: '+ filetimedate+'Time: '+filetimetime,fontsize=15,loc = 'left')
        plt.xlabel('PC1 - {0}%'.format(per_var[0]))
        plt.ylabel('PC2 - {0}%'.format(per_var[1]))
        #for sample in pca_df.index:
         #   plt.annotate(sample, (pca_df.PC1.loc[sample], pca_df.PC2.loc[sample]))
# save the plot to the folder
        plt.savefig(filepath1+filetime+"PCA-Scoring plot.jpg" ,dpi = 300,bbox_inches='tight')
        print("Scoring plot has been saved successfully in the folder: "+ date+"\n")
        plt.show(block=False)
        plt.pause(3)
        plt.close()
        print("prepare for the next analysis\n")
    else:
        print("Only one set of data cannot perform PCA\n")
        print("prepare for the next analysis\n")
        os.chdir(filepath2)
