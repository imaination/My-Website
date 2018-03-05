#!/usr/bin/env python

#import modules
import pandas as pd
import numpy as np
import sys

#get first argument as a csv file
argument = sys.argv[1]

#reading in datafile_csv
data = pd.read_csv(argument, header = None, names = ["id","qid1","qid2","question1","question2","is_duplicate"])


#function to preprocess string
def preprocess(str_in):
    param = ['?','.','!',',','(',')',"'",'"',':'] #parameters to filter
    rm = ['-']                                    #parameter to remove
    str1_out = str(str_in).lower()                #converting strings to lower case
    for p in param:
        if p in str1_out:
            str1_out = str1_out.replace(p, ' ')   #replacing the parameters w/ space
    for d in rm:
        if d in str1_out:
            str1_out = str1_out.replace(d, '')    #replacing the parameter w/ no-space
    return str1_out

questionF = [preprocess(x) for x in data['question1']] #preprocessing question1
questionS = [preprocess(x) for x in data['question2']] #preprocessing question2

questions = {'q1':questionF, 'q2':questionS} #dict of q1 and q2
df = pd.DataFrame(questions)                 #dataframe w/ questions
 
df['isduplicate'] = data['is_duplicate']     #adding the is_duplicate column to the dataframe

#print(df)
