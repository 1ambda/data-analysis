import random
import pylab

# Global Variables
MAXRABBITPOP = 1000
CURRENTRABBITPOP = 500
CURRENTFOXPOP = 30


def rabbitGrowth():
    # you need this line for modifying global variables
    global CURRENTRABBITPOP

    # TO DO
    for i in range(CURRENTRABBITPOP):
        if random.random() < (1 - CURRENTRABBITPOP / float(MAXRABBITPOP)) and \
           CURRENTRABBITPOP <= 1000:
            CURRENTRABBITPOP += 1

            
def foxGrowth():
    # you need these lines for modifying global variables
    global CURRENTRABBITPOP
    global CURRENTFOXPOP

    # TO DO
    for i in range(CURRENTFOXPOP):
        if random.random() < CURRENTRABBITPOP / float(MAXRABBITPOP) and \
           CURRENTRABBITPOP > 10:
            # hunt
            CURRENTRABBITPOP -= 1

            if random.random() < 1/float(3):
                CURRENTFOXPOP += 1

        else:
            if random.random() < 0.9 and \
               CURRENTFOXPOP > 10:
                CURRENTFOXPOP -= 1


def runSimulation(numSteps):
    foxPop = []
    rabbitPop = []

    for i in range(numSteps):
        rabbitGrowth()
        foxGrowth()

        rabbitPop.append(CURRENTRABBITPOP)
        foxPop.append(CURRENTFOXPOP)

    return rabbitPop, foxPop


def visualize(numStep):
    foxPop, rabbitPop = runSimulation(numStep)
    print foxPop
    print rabbitPop
    x = range(numStep)
    # coeff = [a, b, c] where ax^2 + bx + c
    coeff = pylab.polyfit(x, rabbitPop, 2)
    rabbitPred = pylab.polyval(coeff, x)
    coeff = pylab.polyfit(x, foxPop, 2)
    foxPred = pylab.polyval(coeff, x)
    pylab.figure()
    pylab.plot(x, foxPop, "r")
    pylab.plot(x, foxPred, "y")
    pylab.plot(x, rabbitPop, "b")
    pylab.plot(x, rabbitPred, "g")
    pylab.show()

visualize(200)
