#!/usr/bin/env python

#import modules
import sys
from collections import Counter

#import preprocessed dataframe
from Preprocessing import *
from ComputeScore import df, overlap
from ComputeAccuracy import accuracy, isduplicate

#get second argument, threshold
thr = sys.argv[2]
thr = float(thr)

#merge all texts into string format
df['merged'] = df['q1'] + df['q2']

#merging into a one big text
texts = '' #holding space to concatnate strings
for x in range(len(df)): 
    texts+= df.loc[x, 'merged']

text_words = texts.split() #splitting texts into words

#counting occurences of each word in the merged text
counts = Counter(text_words)

#all the words that appeared more than 10000 times are stopwords
stopwords = dict((k,v) for k, v in counts.items() if v > 10000)
stopwords = stopwords.keys() #getting the words

#function to filter stopwords from the preprocessed strings
def stopped(questions, stopwords): #input paramters are the questions and stopwords
    result = []                    #creating a empty list to hold results in later
    for v in questions:            
        stop = [x for x in v.split() if x not in stopwords] #split by word and filter stopwords
        result.append(stop) #append unremoved words into the empty list
    return result

stoppedq1 = stopped(df['q1'],stopwords)
stoppedq2 = stopped(df['q2'],stopwords)

df['q1stopped'] = stoppedq1
df['q2stopped'] = stoppedq2

#calculating the scores and accuracy for stopwords-stripped questions
scores2 = [overlap(a,b) for a,b in zip(df['q1stopped'],df['q2stopped'])]
stoppedaccuracy = accuracy(scores2, isduplicate, thr)

if __name__ == '__main__':
    #print results
    print(stoppedaccuracy)


