import pylab as pl
import numpy as np


def loadFile(fName):
    inFile = open(fName)

    highTemp = []
    lowTemp = []

    for line in inFile:
        fields = line.split()
        if len(fields) == 3 and fields[0].isdigit():
            highTemp.append(int(fields[1]))
            lowTemp.append(int(fields[2]))
    return (highTemp, lowTemp)


def plotTemp(high, low):
    pl.figure(1)
    diff = list(np.array(high) - np.array(low))
    pl.plot(range(1, 32), diff)
    pl.title('Day by Day Ranges in Temperature in Boston in July 2012')
    pl.xlabel('Days')
    pl.ylabel('Temperature Ranges')
    pl.show()


(h, l) = loadFile('julyTemps.txt')
plotTemp(h, l)
