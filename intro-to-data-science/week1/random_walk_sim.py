import random
import pylab


class Location(object):
    def __init__(self, x, y):
        """x and y are floats"""
        self.x = x
        self.y = y

    def move(self, deltaX, deltaY):
        """deltaX and deltaY are floats"""
        return Location(self.x + deltaX, self.y + deltaY)

    def getX(self):
        return self.x

    def getY(self):
        return self.y

    def distFrom(self, other):
        """other is a Location instance"""
        dx = self.x - other.x
        dy = self.y - other.y
        return (dx**2 + dy**2) ** 0.5

    def __str__(self):
        return '<' + str(self.x) + ', ' + str(self.y) + '>'


class Field(object):
    def __init__(self):
        self.drunks = {}

    def addDrunk(self, drunk, loc):
        if drunk in self.drunks:
            raise ValueError('Duplicated drunk')
        else:
            self.drunks[drunk] = loc

    def moveDrunk(self, drunk):
        if drunk not in self.drunks:
            raise ValueError('Drunk is not in this field')

        dx, dy = drunk.takeStep()
        curLoc = self.drunks[drunk]
        self.drunks[drunk] = curLoc.move(dx, dy)

    def getLoc(self, drunk):
        if drunk not in self.drunks:
            raise ValueError('Drunk is not in this field')

        return self.drunks[drunk]


class Drunk(object):
    def __init__(self, name):
        self.name = name

    def ___str__(self):
        return 'This drunk is named: ' + self.name


class UsualDrunk(Drunk):
    def takeStep(self):
        stepChoices = [(0.0, 1.0), (0.0, -1.0), (1.0, 0.0), (-1.0, 0.0)]
        return random.choice(stepChoices)


class ColdDrunk(Drunk):
    def takeStep(self):
        stepChoices = [(0.0, 0.95), (0.0, -1.0), (1.0, 0.0), (-1.0, 0.0)]
        return random.choice(stepChoices)


class EDrunk(Drunk):
    def takeStep(self):
        deltaX = random.random()
        # not biased since there are so many numbers
        if random.random() < 0.5:
            deltaX = -deltaX

        deltaY = random.random()
        if random.random() < 0.5:
            deltaY = -deltaY

        return (deltaX, deltaY)


def walk(f, d, steps):
    start = f.getLoc(d)

    for s in range(steps):
        f.moveDrunk(d)

    return start.distFrom(f.getLoc(d))


def simWalks(steps, trials, drunkClass):
    homer = drunkClass('Homer')
    orgLoc = Location(0, 0)
    distances = []

    for t in range(trials):
        f = Field()
        f.addDrunk(homer, orgLoc)
        distances.append(walk(f, homer, steps))

    return distances


def drunkTest(trials=20):
    # get reproducable results
    random.seed(0)
    # for steps in [0, 1]:
    for steps in [10, 100, 1000, 10000]:
        distances = simWalks(steps, trials)
        print 'Random walk of ' + str(steps) + ' steps'
        print 'Mean = ', sum(distances) / len(distances)
        print ' Max = ', max(distances), 'Min = ', min(distances)


def drunkTestP1(trials=50):
    stepsTaken = [10, 100, 1000, 10000]
    for drunkClass in (UsualDrunk, ColdDrunk, EDrunk):
        meanDistances = []

        for steps in stepsTaken:
            distances = simWalks(steps, trials, drunkClass)
            meanDistances.append(sum(distances) / len(distances))

        pylab.plot(stepsTaken, meanDistances, label=drunkClass.__name__)
        pylab.title('Mean Distance from Origin')
        pylab.xlabel('Steps Taken')
        pylab.ylabel('Steps from Origin')
        pylab.legend(loc='upper left')

    pylab.show()
