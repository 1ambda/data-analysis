import random


def rollDie():
    return random.choice(range(1, 7))


def rollN(n):
    result = ''

    for i in range(n):
        result = result + str(rollDie())

    return result


def getTarget(goal):
    trials = 0
    lenOfRoll = len(goal)

    while True:
        trials += 1
        result = rollN(lenOfRoll)
        if result == goal:
            return trials


def runSim(goal, trials):
    total = 0

    for i in range(trials):
        total += getTarget(goal)

    avgTrials = total / float(trials)
    print 'Prob: ', 1.0/avgTrials

runSim('11111', 1000)
runSim('54324', 1000)
