import os
from collections import Counter

import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder
from tsfresh.feature_selection.significance_tests import target_real_feature_real_test
from tsfresh.feature_selection.relevance import calculate_relevance_table

from visualisation import corrplot


# read feature table
feature_table = '20190920-093139-domain-0_025.csv'
df = pd.read_csv(os.path.join(os.path.abspath(__file__), '..', '..', 'tables', feature_table), index_col=0)
# print(df.head())

X = df.iloc[:,:-10]


def plot_corr_matrix():
    corr = df.iloc[:,:-10].corr()

    plt.figure(figsize=(10, 10))
    corrplot(corr)

    plt.savefig("correlation-matrix.png")
    plt.show()

def significane_test():
    X = df.iloc[:,:-10]
    dummy = np.random.rand(len(df.index))
    X['dummy'] = dummy



    y = df.iloc[:,21:]
    y_single = []
    for i in range(len(y)):
        for j in range(len(y.columns)):
            if y.iloc[i,j] > 0.5:
                y_single.append(j)
                break


    print(len(y_single))
    print(len(y))

    print(y.iloc[30,:])
    print(y_single[30])


    print(Counter(y_single))
        

    # le = LabelEncoder()
    # le.fit(['cel', 'cla', 'flu', 'gac', 'gel', 'org', 'pia', 'sax', 'tru', 'vio'])
    # y_t = le.transform(y)
    y_t = pd.Series(y_single)

    

    print(calculate_relevance_table(X, y_t, ml_task='classification'))



if __name__ == "__main__":
    
    #plot_corr_matrix()
    significane_test()


