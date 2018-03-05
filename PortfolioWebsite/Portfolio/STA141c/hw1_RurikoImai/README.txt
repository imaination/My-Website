#README.txt

Problem 1: Preprocessing.py
Problem 2: ComputeScore.py
Problem 3: ComputeAccuracy.py
Problem 4: AccuracyRemoveStops.py
Problem 5: BestWeight.py


The ComputeScore.py prints all the scores, min, max, median in that order.

The last function (BestWeight.py) needs to have python BestWeight.py training or validation.csv and a threshold (Any threshold will do fine). Also the outputs are both the value and the key since I thought I would want to know the accuracy score as well as the best threshold. 

Ex: python BestWeight.py training.csv 0.5



Note to myself:
if__name__ == '__main__':
    print something

It is there so that it only executes that function when its the main function.
To prevent printing everytime.
