#!/usr/bin/env python

#import modules
import numpy as np
import pandas as pd

#import preprocessed dataframe
from Preprocessing import df

#function to find the score of overlapping words in the paired questions
def overlap(a,b):         #input parameters are the pairs of questions
    count = 0             #initializing count
    a = str(a).split()    #splitting strings into words
    b = str(b).split()
    for x in a:           #searching for matches
        if x in b:
            count+=1      #when it match, add 1 to count
    for y in b:           
        if y in a:
            count+=1
    score = float(count)/(len(a)+len(b)) #calculating the overlapping score
    return(score)

scores = [overlap(a,b) for a,b in zip(df['q1'],df['q2'])] #running the sentences in the overlap function
df['scores'] = scores  #adding scores as a column in df          

min = min(df['scores']) #finding minimum
max = max(df['scores']) #maximum
med = np.median(df['scores']) #median

if __name__ == '__main__':
    #printing stuff
    print(df['scores']) 
    print(min)
    print(max)
    print(med)




