import pylab
import random


def stdDev(xs):
    mean = sum(xs)/float(len(xs))
    total = 0.0
    for x in xs:
        total += (x - mean) ** 2
    return (total / len(xs)) ** 0.5


def runTrial(flips):
    heads = 0
    for n in range(flips):
        if random.random() < 0.5:
            heads += 1

    tails = flips - heads
    return heads, tails


def flipPlot(minExp, maxExp, trials):
    meanRatios = []
    meanDiffs = []
    sdRatios = []
    sdDiffs = []
    xAxis = []

    for exp in range(minExp, maxExp + 1):
        xAxis.append(2 ** exp)

    for flips in xAxis:
        ratios = []
        diffs = []

        for t in range(trials):
            heads, tails = runTrial(flips)
            ratios.append(heads / float(tails))
            diffs.append(abs(heads - tails))
        meanRatios.append(sum(ratios) / trials)
        meanDiffs.append(sum(diffs) / trials)
        sdRatios.append(stdDev(ratios))
        sdDiffs.append(stdDev(diffs))

    pylab.title('Mean of Diff bet Heads and Tails ('+str(trials)+' Trials)')
    pylab.xlabel("# of Flips")
    pylab.ylabel('mean Abs(#Heads - #Tails)')
    pylab.plot(xAxis, meanDiffs, 'bo')
    pylab.semilogx()
    pylab.semilogy()

    pylab.figure()
    pylab.title('SD of Diff bet Heads and Tails ('+str(trials)+' Trials)')
    pylab.xlabel('# of Flips')
    pylab.ylabel('SD Abs(#Heads - #Tails)')
    pylab.plot(xAxis, sdDiffs, 'bo')
    pylab.semilogx()
    pylab.semilogy()

    pylab.figure()
    pylab.title('Mean Heads / Tails Ratios')
    pylab.xlabel('# of Flips')
    pylab.ylabel('mean Heads / Tails')
    pylab.semilogx()
    pylab.plot(xAxis, meanRatios, 'ro')

    pylab.figure()
    pylab.title('SD Heads / Tails Ratios')
    pylab.xlabel('# of Flips')
    pylab.ylabel('SD Heads / Tails')
    pylab.semilogx()
    pylab.semilogy()
    pylab.plot(xAxis, sdRatios, 'ro')

random.seed(0)
flipPlot(4, 20, 20)
pylab.show()
