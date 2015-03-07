import random
import matplotlib.pyplot as pp


def deterministicNumber():
    random.seed(0)
    return random.randrange(10, 21, 2)


def stochasticNumber():
    return random.randrange(10, 21, 2)


def dist1():
    return random.random() * 2 - 1


def dist2():
    if random.random() > 0.5:
        return random.random()
    else:
        return random.random() - 1


def dist3():
    return int(random.random)

dist1Res = []
dist2Res = []

for i in range(0, 10000000):
    dist1Res.append(dist1())
    dist2Res.append(dist2())

pp.figure(1)
pp.hist(dist1Res)
pp.figure(2)
pp.hist(dist2Res)
pp.show()
