#!/usr/bin/env python

#import modules
import sys

#import preprocessed dataframe
from ComputeScore import df, scores

#get second argument, threshold
thr = sys.argv[2]
thr = float(thr) #converting thr from string to float ...

isduplicate = df['isduplicate'] #add isduplicate to df

#function to calculate accuracy scores
def accuracy(a,b,thr):             #input parameters are scores, isduplicate, threshold
    correct = 0.0                  #intializing correct
    for i in range(len(a)):        #loop to serach if scores are <,>= to threshold
        if a[i] >= thr:            #if score is >= than threshold
            right = 1              #right is one
            checked = b[i] == right#if duplicate is 1, checked
        if a[i] < thr:             #if score is < than threshold
            wrong = 0              #wrong is 0
            checked = b[i] == wrong#if duplicate is 0, also checked
        if checked == True:        #if something is checked
            correct+=1             #it is correct
            accurate = correct/(len(a)) #calculate accuracy score
    return accurate


accurate = accuracy(scores, isduplicate, thr) 
#print(accurate)

if __name__ == '__main__':
    print(accurate)
