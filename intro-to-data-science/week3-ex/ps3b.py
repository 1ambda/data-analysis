# Problem Set 3: Simulating the Spread of Disease and Virus Population Dynamics

from ps3b_precompiled_27 import *
import numpy
import random
import pylab


class NoChildException(Exception):
    """"""

#
# PROBLEM 2
#


class SimpleVirus(object):

    def __init__(self, maxBirthProb, clearProb):

        self.maxBirthProb = maxBirthProb
        self.clearProb = clearProb

    def getMaxBirthProb(self):
        return self.maxBirthProb

    def getClearProb(self):
        self.clearProb

    def doesClear(self):
        if random.random() < self.clearProb:
            return True
        else:
            return False

    def reproduce(self, popDensity):
        if random.random() < self.maxBirthProb * (1 - popDensity):
            return SimpleVirus(self.maxBirthProb, self.clearProb)
        else:
            raise NoChildException("can't reproduce")


class Patient(object):

    def __init__(self, viruses, maxPop):
        self.viruses = viruses
        self.maxPop = maxPop

        # TODO

    def getViruses(self):
        return self.viruses

    def getMaxPop(self):
        return self.maxPop

    def getTotalPop(self):
        return len(self.viruses)

    def update(self):

        # clear viruses
        self.viruses = [v for v in self.viruses if not v.doesClear()]

        density = self.getTotalPop() / float(self.maxPop)

        for v in self.viruses:
            try:
                child = v.reproduce(density)
                self.viruses.append(child)
            except NoChildException:
                pass

        return self.getTotalPop()

#
# PROBLEM 3
#


def simulationWithoutDrug(numViruses, maxPop, maxBirthProb, clearProb,
                          numTrials):
    population = []
    steps = 300

    for p in range(0,  steps):
        population.append([])

    for t in range(0, numTrials):
        # instantiate viruses
        viruses = []
        for i in range(numViruses):
            viruses.append(SimpleVirus(maxBirthProb, clearProb))

        # instantiate a patient
        patient = Patient(viruses, maxPop)

        # consume time steps
        for step in range(0, steps):
            population[step].append(patient.update())

    avgP = [float(sum(p)) / numTrials for p in population]

    pylab.plot(range(steps), avgP)
    pylab.title('SimpleVirus simulation')
    pylab.xlabel('Time Steps')
    pylab.ylabel('Average Virus Population')
    pylab.show()

# simulationWithoutDrug(100, 1000, 0.1, 0.05, 30)

#
# PROBLEM 4
#


class ResistantVirus(SimpleVirus):
    def __init__(self, maxBirthProb, clearProb, resistances, mutProb):
        SimpleVirus.__init__(self, maxBirthProb, clearProb)
        self.resistances = resistances
        self.mutProb = mutProb

    def getResistances(self):
        return self.resistances

    def getMutProb(self):
        return self.mutProb

    def isResistantTo(self, drug):
        return self.resistances.get(drug, False)

    def reproduce(self, popDensity, activeDrugs):
        # check if it is resistant to ALL the drugs in the activeDrugs
        for drug in activeDrugs:
            if not self.isResistantTo(drug):
                raise NoChildException("can't reproduce")

        # reproduce
        if random.random() <= (self.maxBirthProb * (1 - popDensity)):
            # mutate
            childResistance = {}
            for drug in self.getResistances():
                childResistance[drug] = self.mutate(self.isResistantTo(drug))

            return ResistantVirus(self.getMaxBirthProb(), self.getClearProb(), childResistance, self.getMutProb())
        else:
            raise NoChildException("can't reproduce")

    def mutate(self, current):
        if random.random() <= self.mutProb:
            return not(current)  # mutate resistance
        else:
            return current


class TreatedPatient(Patient):
    def __init__(self, viruses, maxPop):
        Patient.__init__(self, viruses, maxPop)
        self.prescriptions = []

    def addPrescription(self, newDrug):
        if newDrug not in self.getPrescriptions():
            self.prescriptions.append(newDrug)

    def getPrescriptions(self):
        return self.prescriptions

    def getResistPop(self, drugResist):
        population = 0
        for v in self.getViruses():
            if all([v.isResistantTo(drug) for drug in drugResist]):
                population += 1

        return population

    def update(self):
        # clear viruses
        self.viruses = [v for v in self.viruses if not v.doesClear()]
        reproduced = []

        for v in self.viruses:
            # calculate density
            density = self.getTotalPop() / float(self.maxPop)

            try:
                newVirus = v.reproduce(density, self.prescriptions)
                reproduced.append(newVirus)
            except NoChildException:
                pass

        self.viruses += reproduced
        return self.getTotalPop()

#
# PROBLEM 5
#


def simulationWithDrug(numViruses, maxPop, maxBirthProb, clearProb, resistances,
                       mutProb, numTrials):
    virusPopulation = []
    grVirusPopulation = []  # guttagonol-resistant
    testDrugs = ['guttagonol']

    steps1 = 150
    steps2 = 150  # guttagonol-resistant step
    totalStep = steps1 + steps2

    for s in range(totalStep):
        virusPopulation.append([])
        grVirusPopulation.append([])

    for t in range(numTrials):
        # create viruses
        viruses = [ResistantVirus(maxBirthProb, clearProb, resistances, mutProb) for i in range(numViruses)]
        patient = TreatedPatient(viruses, maxPop)

        # step1
        for s1 in range(totalStep):
            if s1 == 150:
                # step2 : guttagonol-resistant test
                for drug in testDrugs:
                    patient.addPrescription(drug)

            virusPopulation[s1].append(patient.update())  # total population
            grVirusPopulation[s1].append(patient.getResistPop(testDrugs))  # resist population

    avgPopulation = [sum(p) / float(numTrials) for p in virusPopulation]
    avgResistPopulation = [sum(rp) / float(numTrials) for rp in grVirusPopulation]

    # print avgPopulation
    pylab.plot(range(totalStep), avgPopulation, label='total pop')
    pylab.plot(range(totalStep), avgResistPopulation, label='resist pop')
    pylab.xlabel('time step')
    pylab.ylabel('# viruses')

    pylab.title('ResistantVirus simulation')
    pylab.legend(loc='upper right')
    pylab.show()

#simulationWithDrug(1, 10, 1.0, 0.0, {}, 1.0, 5)
# simulationWithDrug(35, 100, .8, 0.2, {"guttagonol": True}, 0.9, 10)
simulationWithDrug(100, 1000, 0.1, 0.05, {"guttagonol": False}, 0.005, 100)
