# 6.00.2x Problem Set 4

import numpy
import random
import pylab
from ps3b import *

#
# PROBLEM 1
#


def simulationDelayedTreatment(trials):
    numViruses = 100
    maxPop = 1000
    maxBirthProb = 0.1
    clearProb = 0.05
    mutProb = 0.005

    beforeTreatment = [300, 150, 75, 0]
    afterTreatment = 150

    finalTotVirus = {}
    for b in beforeTreatment:
        finalTotVirus[b] = []

    for t in range(trials):
        for b in beforeTreatment:
            resistances = {"guttagonol": False}
            viruses = [ResistantVirus(maxBirthProb, clearProb, resistances, mutProb) for i in range(numViruses)]
            patient = TreatedPatient(viruses, maxPop)
            lastPop = 0

            # delayed 
            for i in range(b):
                patient.update()

            # after treatment
            patient.addPrescription("guttagonol")

            for j in range(afterTreatment):
                lastPop = patient.update()

            finalTotVirus[b].append(lastPop)

    histNum = len(beforeTreatment)
    colors = ['blue', 'red', 'yellow', 'green']

    for k in range(histNum):
        delayed = beforeTreatment[k]
        pylab.subplot(histNum, 1, k + 1)
        pylab.title("delayed: " + str(delayed))
        pylab.hist(finalTotVirus[delayed], color=colors[k])

    pylab.show()

# simulationDelayedTreatment(100)

#
# PROBLEM 2
#


def simulationTwoDrugsDelayedTreatment(trials):
    numViruses = 100
    maxPop = 1000
    maxBirthProb = 0.1
    clearProb = 0.05
    mutProb = 0.010

    # firstTreatment = [300, 150, 75, 0]
    firstTreatment = [150]
    secondTreatment = 150

    finalTotVirus = {}
    for b in firstTreatment:
        finalTotVirus[b] = []

    for t in range(trials):
        for b in firstTreatment:
            resistances = {"guttagonol": False, "grimpex": False}
            viruses = [ResistantVirus(maxBirthProb, clearProb, resistances, mutProb) for i in range(numViruses)]
            patient = TreatedPatient(viruses, maxPop)
            lastPop = 0

            # delayed
            for h in range(150):
                patient.update()

            # first treatment: guttagonol
            patient.addPrescription("guttagonol")
            for i in range(b):
                patient.update()

            # second treatment: grimpex
            patient.addPrescription("grimpex")
            for j in range(secondTreatment):
                lastPop = patient.update()

            finalTotVirus[b].append(lastPop)

    histNum = len(firstTreatment)
    colors = ['blue', 'red', 'yellow', 'green']

    for k in range(histNum):
        delayed = firstTreatment[k]
        pylab.subplot(histNum, 1, k + 1)
        pylab.title("delayed: " + str(delayed))
        pylab.hist(finalTotVirus[delayed], color=colors[k])

    pylab.show()

simulationTwoDrugsDelayedTreatment(100)
