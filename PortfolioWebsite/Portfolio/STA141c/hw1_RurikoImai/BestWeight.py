#!/usr/bin/env python

import sys
from ComputeAccuracy import accuracy, isduplicate
from ComputeScore import scores
from AccuracyRemoveStops import scores2


def bestweight(a,b):
    thr = [0.1,0.2,0.3,0.4,0.45,0.5,0.55,0.6,0.7,0.8,1]
    accurate = [accuracy(a, b, x) for x in thr]
    mydict = {"0.1":accurate[0],"0.2":accurate[1],"0.3":accurate[2],"0.4":accurate[3],"0.45":accurate[4],"0.5":accurate[5],"0.55":accurate[6],"0.6":accurate[7],"0.7":accurate[8],"0.8":accurate[9],"1":accurate[10]}
    maximum = max(mydict, key=mydict.get)  #finding max accuracy
    return (maximum, mydict[maximum])

best1 = bestweight(scores, isduplicate)
best2 = bestweight(scores2, isduplicate)

print(best1)
print(best2)
