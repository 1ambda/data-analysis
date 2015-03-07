import random
import pylab


def lvMethod(balls, color):

    selected = -1 # non exist color
    trials = 0

    while (selected != color):
        selected = random.choice(balls)
        trials += 1

    return trials


def mcMethod(balls, color, k):
    count = 1
    size = len(balls)
    selected = random.choice(balls)

    if selected == color:
        # return 1
        return count 
    else:
        while (count < k):
            count += 1
            selected += 1
            if balls[selected % size] == color:
                return count

        return 0

        
def subProblem():
    size = 1000
    # 0 : white, 1 : black, assume unifomly filled
    balls = [random.choice([0, 1]) for i in range(0, size + 1)]
    histogram = [0] * size

    for i in range(size):
        # result = lvMethod(balls, 0)
        result = mcMethod(balls, 0, 2)
        histogram[result] += 1

    pylab.plot(range(size), histogram, "r")
    pylab.show()

subProblem()
