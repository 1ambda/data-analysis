import random, pylab


def noReplacementSimulation(trials):

    count = 0

    for t in range(trials):
        bucket = ['g', 'g', 'g', 'r', 'r', 'r']
        selected = []

        for n in range(3):
            ball = random.choice(bucket)
            selected.append(ball)
            bucket.remove(ball)

        # if selected balls have same color
        if len(set(selected)) == 1:
            count += 1

    return count / float(trials)


def stdDev(X):
    mean = sum(X) / float(len(X))
    total = 0.0
    for x in X:
        total += (x - mean) ** 2
    return (total / len(X)) ** 0.5


def dropNeedles(num):
    inCircle = 0
    for needles in xrange(1, num + 1, 1):
        x = random.random()
        y = random.random()

        if (x*x + y*y) ** 0.5 <= 1.0:
            inCircle += 1

    return 2 * (inCircle / float(num))


def estimate(numOfNeedles, trials):
    estimates = []
    for i in range(trials):
        pi = dropNeedles(numOfNeedles)
        estimates.append(pi)

    sd = stdDev(estimates)
    est = sum(estimates) / len(estimates)

    return (est, sd)


def simulate(precision, trials):
    numOfNeedles = 1000
    sd = precision

    # 95% of the values lie within precision of the mean
    while sd >= (precision / 2.0):
        est, sd = estimate(numOfNeedles, trials)
        print 'PI est =', est, "sd =", round(sd, 6), "needles =", numOfNeedles
        numOfNeedles *= 2

    return est


# random.seed(0)
# simulate(0.005, 100)

