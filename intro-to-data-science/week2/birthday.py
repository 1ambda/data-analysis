import operator


def atLeastTwoSameBirthday(n):
    xs = range(365 - n, 365)
    ys = map((lambda x: float(x) / 365), xs)
    return 1 - reduce(operator.mul, ys)


def minNumOfPeopleProb(p):
    for n in range(1, 365):
        if atLeastTwoSameBirthday(n) >= p:
            return n

    return n


print atLeastTwoSameBirthday(29)
print atLeastTwoSameBirthday(249)
print minNumOfPeopleProb(0.99)
