import pylab
import random


def stdDev(xs):
    mean = sum(xs)/float(len(xs))
    total = 0.0
    for x in xs:
        total += (x - mean) ** 2
    return (total / len(xs)) ** 0.5


def flip(flips):
    heads = 0.0
    for i in range(flips):
        if random.random() < 0.5:
            heads += 1
    return heads / flips


def flipSim(flipsPerTrial, trials):
    fracHeads = []
    for i in range(trials):
        fracHeads.append(flip(flipsPerTrial))

    mean = sum(fracHeads) / len(fracHeads)
    sd = stdDev(fracHeads)
    return (fracHeads, mean, sd)


def labelPlot(flips, trials, mean, sd):
    pylab.title(str(trials) + 'trials of '
                + str(flips) + ' flips each')
    pylab.xlabel('Fracion of Heads')
    pylab.ylabel('# of Trials')
    xmin, xmax = pylab.xlim()
    ymin, ymax = pylab.ylim()
    pylab.text(xmin + (xmax - xmin) * 0.02, (ymax-ymin) / 2,
               'mean = ' + str(round(mean, 4))
               + '\nSD = ' + str(round(sd, 4)))


def makePlots(flips1, flips2, trials):
    val1, mean1, sd1 = flipSim(flips1, trials)
    pylab.hist(val1, bins=21)
    xmin, xmax = pylab.xlim()
    ymin, ymax = pylab.ylim()
    labelPlot(flips1, trials, mean1, sd1)

    pylab.figure()
    val2, mean2, sd2 = flipSim(flips2, trials)
    pylab.hist(val2, bins=21)
    pylab.xlim(xmin, xmax)
    ymin, ymax = pylab.ylim()
    labelPlot(flips2, trials, mean2, sd2)


def exampleHist(n):
    xs = []
    for x in range(n):
        xs.append(random.random())

    pylab.hist(xs, bins=11)
    pylab.xlim(-1.0, 2.0)
    pylab.show()

random.seed(0)
makePlots(100, 1000, 100000)
pylab.show()
